import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:advstory/src/advstory.dart';
import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/controller/advstory_controller.dart';
import 'package:advstory/src/model/story.dart';
import 'package:advstory/src/model/story_position.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/util/cron.dart';
import 'package:advstory/src/view/components/contents/image_content.dart';
import 'package:advstory/src/view/components/contents/video_content.dart';
import 'package:advstory/src/view/components/tray/animated_tray.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:advstory/src/view/inherited_widgets/content_position_provider.dart';
import 'package:flutter/material.dart';

const _excMessage = 'AdvStory fields didn\'t set yet, '
    'use any AdvStory method after super.didChangeDependencies().';

/// Base class for story contents. Every story content type must be a subtype
/// of this class.
abstract class AdvStoryContent extends Widget {
  /// Constructor of [AdvStoryContent].
  const AdvStoryContent({Key? key}) : super(key: key);
}

/// Base class for story contents. Advanced story types should extend this class
/// to use [AdvStory] capability.
abstract class StoryContent extends StatefulWidget implements AdvStoryContent {
  /// Default constructor of [StoryContent]. [StoryContentState] provides very
  /// useful methods to handle story events and loading, caching media and must
  /// returned from [createState]. [ImageContent] and [VideoContent] types
  /// extends this class.
  const StoryContent({Key? key}) : super(key: key);

  @override
  StoryContentState<StoryContent> createState();
}

/// State class for StoryContent. This class provides AdvStory functionality
/// to story contents.
abstract class StoryContentState<T extends StoryContent> extends State<T> {
  final _cron = Cron();
  ContentPositionProvider? _positionProvider;
  DataProvider? _dataProvider;
  late final Duration _contentDuration;
  StoryStatus _status = StoryStatus.stop;

  /// Used to wait for the content to be ready. This future is completed when
  /// `markReady` is called.
  final _preparation = Completer<void>();

  /// Returns this contents position.
  StoryPosition get position {
    assert(_positionProvider != null, _excMessage);
    return _positionProvider!.position;
  }

  /// Custom loading screen or AdvStory default loading screen. It is
  /// recommended to use this loading screen to maintain visual integrity.
  Widget get loadingScreen {
    assert(_dataProvider != null, _excMessage);
    return _dataProvider!.style();
  }

  /// Returns true if this content is the first item in the tapped tray.
  ///
  /// This is different from 0th position.
  /// For example, when user tapped on the second tray, if this contents
  /// position is (2,0) this method will return true, but if this contents
  /// position is (3,0) this method will return false.
  bool get isFirstContent {
    assert(_dataProvider != null, _excMessage);

    return _dataProvider!.positionNotifier.initialPosition == position &&
        _dataProvider!.positionNotifier.story == position.story;
  }

  /// If the tray of this content is an [AnimatedTray] and this content is the
  /// first content in story, `AdvStory` builds your content but keeps it off
  /// screen until you call `markReady`.
  ///
  /// Building an animated loading screen is completely unnecessary in this
  /// case. You can check this to not render a loading screen when the content
  /// is not ready.
  ///
  /// _This might increase opening performance significantly._
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  if (isMyResourcesLoaded) {
  ///   return buildMyContent();
  ///  }
  ///
  ///  return shouldShowLoading ? loadingScreen : const SizedBox();
  /// }
  /// ```
  bool get shouldShowLoading {
    assert(_dataProvider != null, _excMessage);
    if (!isFirstContent) return true;

    return !_dataProvider!.positionNotifier.trayWillAnimate;
  }

  /// Provided or default AdvStoryController.
  ///
  /// **No need to use addListener method to listening events in the flow.
  /// Override [onStart], [onPause], [onResume] and [onStop] methods to handle
  /// events related to this content. This methods only called events that are
  /// related with this content.**
  AdvStoryController get controller {
    assert(_dataProvider != null, _excMessage);
    return _dataProvider!.controller;
  }

  /// Fetch a file from the given url and cache it to local storage.
  ///
  /// ---
  /// If you want to use your own cache, no need to use this method.
  Future<File> loadFile({
    String? cacheKey,
    Map<String, String>? requestHeaders,
    required String url,
  }) async {
    return await BuildHelper().getMediaFile(
      url: url,
      cacheKey: cacheKey,
      requestHeaders: requestHeaders,
    );
  }

  /// Marks the story content as ready to start. Call this method when content
  /// is ready to be display.
  ///
  /// When you call this method, if current position is the position of this
  /// content, story flow starts immediately for the given [Duration],
  /// otherwise this content will be marked as ready and AdvStory will start
  /// the flow for this content when necessary.
  ///
  /// If an [AnimatedTray] provided to AdvStory and this content is the first
  /// item in the story view of tray, tray animation continues to play until
  /// this method is called.
  ///
  /// ---
  /// - For example, if you want to show a video use [loadFile] method to load
  /// resource from internet, create VideoPlayerController and initialize it.
  /// Then, call [markReady] to mark this content as ready.
  void markReady({required Duration duration}) {
    assert(_positionProvider != null, _excMessage);
    if (_preparation.isCompleted) {
      log(
        'Looks like you\'re doing something wrong!',
        name: 'AdvStory',
        error: '-> Description: \n'
            'markReady called more than once!\n'
            '-> Details: \n'
            'Content position: ${position.toString()}'
            'This might indicate your initialization process executed multiple '
            'times and this might cause significant performance issues.\n'
            '-> Hint: \n'
            'The preferred solution is preaparing content in initContent() '
            'and then calling markReady. If you\'re still having problems after'
            ' doing that, please file an issue.',
        stackTrace: StackTrace.current,
      );

      return;
    }

    _cron.stop();
    _contentDuration = duration;
    _preparation.complete();
    if (isFirstContent) _dataProvider!.markFirstReady();
  }

  Future<void> _starter() async {
    final pos = _dataProvider!.positionNotifier;

    // This content is on screen but status changed.
    if (pos == position) {
      if (pos.status.shouldPlay) {
        await _preparation.future;
        _dataProvider!.controller.flowManager.start(
          position,
          _contentDuration,
        );
        onStart();
      } else if (pos.status.shouldPause) {
        onPause();
      } else {
        onResume();
      }

      _status = pos.status;
    }
    // Story skipped
    else if (pos != position && !_status.shouldStop) {
      _status = StoryStatus.stop;
      onStop();
    }
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_positionProvider == null) {
      _positionProvider = ContentPositionProvider.of(context)!;
      _dataProvider = DataProvider.of(context)!;

      _dataProvider!.positionNotifier.addListener(
        _starter,
        position: position,
      );

      initContent();
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    _dataProvider!.positionNotifier.removeListener(_starter);
    super.dispose();
  }

  /// Called when [StoryContent] is finished its initialization. You can call
  /// methods provided by [StoryContentState] inside of this method.
  /// `initContent` method is the first place that you can use provided methods.
  ///
  /// Or alternatively, you can use `AdvStory` methods inside of:
  /// - `initState` like below:
  ///
  /// > ```dart
  /// @override
  /// void initState() {
  ///  super.initState();
  ///  SchedulerBinding.instance.addPostFrameCallback((_) {
  ///    // Your code here
  ///  });
  /// }
  /// > ```
  ///
  /// - `didChangeDependencies`, after super call.
  ///
  /// > ```dart
  /// @override
  /// void didChangeDependencies() {
  ///   super.didChangeDependencies();
  ///   // Your code here
  /// }
  /// > ```
  ///
  /// ---
  /// ---
  /// There are some differences between using `initContent` and
  /// `didChangeDependencies` or `initState`:
  ///
  /// - `initContent` runs only **once** immediately after
  /// `didChangeDependecies.super()` call.
  ///
  /// - `didChangeDependencies` may be called multiple times by framework. You
  /// should not put the code that you want to run once to
  /// `didChangeDependencies`.
  ///
  /// - When `postFrameCallback` or other alternatives like `Future.delayed`,
  /// `Timer.run`, `WidgetsBinding` used in `initState` your code will run
  /// after the first build phase.
  FutureOr<void> initContent() {}

  /// Sets a timeout to call [markReady]. Use this method to set a time limit to
  /// take action when your content isn't ready at the requested time. Create
  /// your action in the [onTimeout] method.
  ///
  /// [markReady] cancels the timeout when called.
  void setTimeout(Duration timeout) =>
      _cron.start(onComplete: onTimeout, duration: timeout);

  /// Called when the end of the set timeout is reached.
  ///
  /// ---
  /// For example, in this method you can show an error message to your user
  /// and then you can use [controller] to skip to the next content.
  void onTimeout() {}

  /// This method is called when content is on screen and should start.
  /// Start your video, audio or any progressing content inside of this method.
  ///
  /// ---
  /// - For example, if you want to play a video, you should start it inside of
  /// this method.
  void onStart() {}

  /// This method is called when story is resumed. It is called after the
  /// [onPause] method.
  ///
  /// **Every tap pauses story, this method works very often, do not do
  /// expensive operations to avoid performance issues.**
  ///
  /// ---
  /// - For example, if you are playing a video, you should resume it inside of
  /// this method.
  void onResume() {}

  /// Called when the story is paused. In this method, pause video, audio or
  /// any other progressing content but do not reset its progress.
  /// Usually content persists from the same state after this method called.
  ///
  /// **Every tap pauses story, this method works very often, do not do
  /// expensive operations to avoid performance issues.**
  ///
  /// ---
  /// - For example, if you are playing a video, you should pause it inside of
  /// this method.
  void onPause() {}

  /// Called when story is not visible on screen and should stop. Stop any
  /// progressing content and reset it's progress to prevent from playing while
  /// this content is not visible.
  ///
  /// **Don't dispose anything, resources may be used still.**
  ///
  /// ---
  /// - For example, if you are playing a video, you should pause and reset it's
  /// progress inside of this method.
  void onStop() {}
}

/// Base class for [ImageContent] and [VideoContent].
abstract class ManagedContent extends StoryContent {
  /// Creates a story content managed by [AdvStory].
  const ManagedContent({
    required this.url,
    this.requestHeaders,
    this.cacheKey,
    this.header,
    this.footer,
    this.timeout,
    this.errorBuiler,
    Key? key,
  }) : super(key: key);

  /// Media source url.
  final String url;

  /// Headers to use when getting the media file.
  final Map<String, String>? requestHeaders;

  /// Key to use when caching media file. Useful if the url has parameters
  /// like timestamp, token etc.
  final String? cacheKey;

  /// Upper section of the content. This header overrides the header provided
  /// to [Story]. If this is null, [Story] header is used.
  final Widget? header;

  /// Bottom section of the content. This footer overrides the footer provided
  /// to [Story]. If this is null, [Story] footer is used.
  final Widget? footer;

  /// Time limit to prepare this content.
  final Duration? timeout;

  /// Builder to create error view to show when media couldn't loaded
  /// in [timeout].
  final Widget Function()? errorBuiler;

  @override
  StoryContentState<ManagedContent> createState();
}

/// Shortcut for determining [StoryStatus] state.
extension StatusComparer on StoryStatus {
  bool get shouldPlay => this == StoryStatus.play;
  bool get shouldPause => this == StoryStatus.pause;
  bool get shouldStop => this == StoryStatus.stop;
}

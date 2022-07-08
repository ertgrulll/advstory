import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/advstory_controller.dart';
import 'package:advstory/src/controller/advstory_controller_impl.dart';
import 'package:advstory/src/controller/advstory_player_controller.dart';
import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/view/components/story_indicator.dart';
import 'package:advstory/src/view/story_view.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:advstory/src/view/tray_view.dart';
import 'package:flutter/material.dart';

/// An advanced, complete story viewer. Has support for images, videos,
/// custom widget contents, gestures, interceptors, listeners, manipulators
/// and much more. Designed for performance.
///
/// ___
/// _Quite easy & Quite advanced_
class AdvStory extends StatefulWidget {
  /// Creates a story tray list using [trayBuilder]. When a tray tapped calls
  /// [storyBuilder] and starts story flow.
  /// ___
  /// [controller] :
  /// {@macro advstory.storyController}
  const AdvStory({
    required this.storyCount,
    required this.storyBuilder,
    required this.trayBuilder,
    AdvStoryController? controller,
    this.buildStoryOnTrayScroll = true,
    this.preloadStory = true,
    this.preloadContent = true,
    this.style = const AdvStoryStyle(),
    Key? key,
  })  : storyController = controller,
        hasTrays = true,
        super(key: key);

  /// Creates a story tray list using [trayBuilder]. When a tray tapped calls
  /// [storyBuilder] and starts story flow.
  /// ___
  /// [controller] :
  /// {@macro advstory.storyController}
  const AdvStory.player({
    Key? key,
    required this.storyCount,
    required this.storyBuilder,
    this.preloadContent = true,
    this.preloadStory = true,
    this.style = const AdvStoryStyle(),
    required AdvStoryPlayerController controller,
  })  : hasTrays = false,
        buildStoryOnTrayScroll = false,
        trayBuilder = null,
        storyController = controller,
        super(key: key);

  /// Determines if should build [TrayView] or [StoryView].
  final bool hasTrays;

  /// {@template advstory.style}
  /// Styles for the `AdvStory`. Provides customization options
  /// for [StoryIndicator], [LoadingStyle], [TrayListStyle] and other
  /// more general options.
  /// {@endtemplate}
  final AdvStoryStyle style;

  /// {@template advstory.storyController}
  /// A controller for manipulating flow and listening user interactions.
  ///
  /// Provides methods to skip, pause, resume contents and
  /// stories, show and hide widgets on story contents, enable or disable
  /// gestures, capture and block events before they happen and more.
  /// {@endtemplate}
  final AdvStoryController? storyController;

  /// The number of [Story]s to build and display.
  final int storyCount;

  /// The builder function that will be called to build a [Story].
  ///
  /// This function can be async to provide lazy loading.
  /// ___
  ///
  /// Story builder returns a [Story], which is:
  /// {@macro advstory.story}
  final StoryBuilder storyBuilder;

  /// {@template advstory.trayBuilder}
  /// Builds a widget that shown in list for every story.
  /// Most probably story owner's profile picture.
  ///
  /// Each story must have a tray.
  /// {@endtemplate}
  final TrayBuilder? trayBuilder;

  /// {@template advstory.buildStoryOnTrayScroll}
  /// Sets whether stories are build when tray list is scrolled or the tray is
  /// tapped.
  ///
  /// Speeds up the opening time of story view when tray is tapped if this set
  /// to true but increases frequency of calling [storyBuilder]. If you are
  /// requesting data from server in [storyBuilder] you may want to set this
  /// to false to avoid rate limit.
  /// {@endtemplate}
  final bool buildStoryOnTrayScroll;

  /// {@template advstory.preloadStory}
  /// Sets whether story preload is enabled.
  ///
  /// When set to true, _three_ story and some of it's content
  /// (depends on [preloadContent]) are loaded into memory at a time.
  ///
  /// When set to false, only loads _one_ story and some of its contents into
  /// memory at a time.
  ///
  /// If you are seeing memory issues or lags, you can set this to false.
  /// If your content is mostly video, consider checking the media sizes as
  /// well. Large videos can cause problems, in which case you might want to
  /// set this to false.
  /// {@endtemplate}
  final bool preloadStory;

  /// {@template advstory.preloadContent}
  /// Sets whether content preload is enabled or not.
  ///
  /// When set to true, loads _three_ content into memory at a time.
  /// When set to false, only loads _one_ content into memory at a time.
  ///
  /// _Setting this to false significantly reduces performance._
  ///
  /// Default value is `true`. Most of the time you don't need to disable this.
  /// You might want to set this to false only if your content is mostly video
  /// and you don't have control over video sizes.
  /// {@endtemplate}
  final bool preloadContent;

  @override
  State<AdvStory> createState() => _AdvStoryState();
}

class _AdvStoryState extends State<AdvStory> with TickerProviderStateMixin {
  late final AdvStoryControllerImpl _controller;
  late final _buildHelper = BuildHelper(
    storyBuilder: widget.storyBuilder,
    cacheStories: widget.hasTrays,
  );

  /// Active progress indicator value controller.
  late final AnimationController _indicatorController;

  /// Controls indicator, header and footer visibility.
  late final AnimationController _opacityController;

  @override
  void initState() {
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      value: 1.0,
    );
    _indicatorController = AnimationController(vsync: this);

    _controller = (widget.storyController ?? AdvStoryController())
        as AdvStoryControllerImpl;
    _controller
      ..storyCount = widget.storyCount
      ..setAnimationControllers(
        indicatorController: _indicatorController,
        opacityController: _opacityController,
      );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AdvStory oldWidget) {
    if (oldWidget.storyCount != widget.storyCount) {
      _controller.storyCount = widget.storyCount;
    }

    if (!widget.hasTrays && oldWidget.storyBuilder != widget.storyBuilder) {
      _buildHelper.storyBuilder = widget.storyBuilder;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _indicatorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasTrays) {
      return TrayView(
        buildHelper: _buildHelper,
        buildStoryOnTrayScroll: widget.buildStoryOnTrayScroll,
        controller: _controller,
        preloadContent: widget.preloadContent,
        preloadStory: widget.preloadStory,
        style: widget.style,
        trayBuilder: widget.trayBuilder!,
      );
    }

    return ValueListenableBuilder(
      valueListenable: _controller.positionNotifier.shouldShowView,
      builder: (context, bool value, child) {
        if (!value) return const SizedBox();

        return DataProvider(
          hasTrays: false,
          controller: _controller,
          buildHelper: _buildHelper,
          style: widget.style,
          preloadStory: widget.preloadStory,
          preloadContent: widget.preloadContent,
          child: const SizedBox.expand(child: StoryView()),
        );
      },
    );
  }
}

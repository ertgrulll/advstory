import 'dart:async';

import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/advstory_controller.dart';
import 'package:advstory/src/controller/story_controller_impl.dart';
import 'package:advstory/src/model/cluster.dart';
import 'package:advstory/src/model/story_position.dart';
import 'package:advstory/src/model/story_resource.dart';
import 'package:advstory/src/model/style/advstory_style.dart';
import 'package:advstory/src/model/types/image_story.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/model/types/video_story.dart';
import 'package:advstory/src/model/types/widget_story.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/view/cluster_view.dart';
import 'package:advstory/src/view/components/tray/animated_tray.dart';
import 'package:advstory/src/view/components/tray/animation_manager.dart';
import 'package:advstory/src/view/components/tray/animation_notifier.dart';
import 'package:advstory/src/view/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// AdvStory is a package that helps you to create stories.
class AdvStory extends StatefulWidget {
  /// An advanced story viewer for flutter.
  ///
  /// Available Gestures:
  /// * Swipe right: skips previous cluster if available, otherwise does nothing
  /// * Swipe left: skips next cluster if available, otherwise closes story view
  /// * Swipe down: closes story view.
  /// * Touch to right: skip to next story or skip to next cluster if available,
  ///  otherwise closes story view.
  /// * Touch to left: skip to previous story or skip to previous cluster
  /// if available, otherwise does nothing.
  /// * Long press: pauses story.
  /// * Releasing long press: resumes story.
  const AdvStory({
    required this.clusterCount,
    required this.clusterBuilder,
    required this.trayBuilder,
    this.controller,
    this.style = const AdvStoryStyle(),
    this.buildClustersOnTrayScroll = true,
    this.hideBars = true,
    Key? key,
  }) : super(key: key);

  /// Styles for the AdvStory.
  final AdvStoryStyle style;

  /// Provides methods for manuplating default story flow and listening events.
  final AdvStoryController? controller;

  /// The number of [Cluster]s to build and display.
  final int clusterCount;

  /// Builds the [Cluster]s.
  ///
  /// This fumction can be async to provide lazy loading.
  final ClusterBuilder clusterBuilder;

  /// Builds a widget that shown in list for every cluster.
  /// Most probably cluster owner's profile picture.
  ///
  /// Each cluster must have a tray.
  final TrayBuilder trayBuilder;

  /// Sets whether clusters are build when tray list is scrolled or the tray is
  /// tapped.
  ///
  /// Speeds up the opening time of story view when tray is tapped if this set
  /// to true, also increases frequency of calling [clusterBuilder]. If you are
  /// requesting data from server in [clusterBuilder] you may want to set this
  /// to false.
  /// Default value is `true`.
  final bool buildClustersOnTrayScroll;

  /// Sets the story view to be full screen or not. Default value is `true`.
  /// Hides status and navigation bars when story view opened.
  final bool hideBars;

  @override
  State<AdvStory> createState() => _AdvStoryState();
}

class _AdvStoryState extends State<AdvStory> with TickerProviderStateMixin {
  late final AdvStoryControllerImpl _controller;
  late final _buildHelper = BuildHelper(clusterBuilder: widget.clusterBuilder);
  bool _canShowCluster = true;

  /// Active progress indicator value controller.
  late final _indicatorController = AnimationController(vsync: this);

  /// Controls indicator, header and footer visibility.
  late final _opacityController = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
    value: 1.0,
  );

  @override
  void initState() {
    // Cast controller to AdvStoryControllerImpl to access required methods and
    // provide required params.
    _controller =
        ((widget.controller ?? AdvStoryController()) as AdvStoryControllerImpl)
          ..initialize(
            indicatorController: _indicatorController,
            opacityController: _opacityController,
          );

    super.initState();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _indicatorController.dispose();

    super.dispose();
  }

  /// Makes story ready before showing, this provides a smoother transition and
  /// prevents loading screen from showing on first view.
  /// This function is called if story tray is a subclass of [AnimatedTray].
  ///
  /// Downloads and caches media file, creates [VideoPlayerController] if
  /// story is a [VideoStory], precaches image if story is an [ImageStory].
  Future<void> _prepareMedia(int index) async {
    final cluster = await _buildHelper.buildCluster(index);
    final story = cluster.storyBuilder(0);

    if (story is WidgetStory || !mounted) return;

    story as ManagedStory;

    final file = await _buildHelper.getMediaFile(
      url: story.url,
      headers: story.requestHeaders,
      key: story.cacheKey,
    );

    if (!mounted) return;
    late final StoryResource resource;

    if (story is ImageStory) {
      final image = FileImage(file);
      await precacheImage(image, context);

      resource = ImageResource(
        isLoaded: true,
        image: image,
      );
    } else {
      final videoController = VideoPlayerController.file(file);
      await videoController.initialize();
      resource = VideoResource(
        isLoaded: true,
        videoController: videoController,
      );
    }

    _controller.flowManager.addResource(
      resource,
      StoryPosition(0, index),
    );
  }

  /// Opens the [ClusterView] according to given index.
  /// [index] is tapped tray index and so cluster index to display.
  Future<void> _show({
    required BuildContext context,
    required int index,
    AnimationManager? manager,
  }) async {
    if (manager != null) {
      await _prepareMedia(index);
      manager.notifier.notifyListeners(shouldAnimate: false);
    }
    _canShowCluster = true;

    if (!mounted) return;

    // Set cluster PageController to start from the given index.
    _controller.clusterController = ExtendedPageController(
      initialPage: index,
      itemCount: widget.clusterCount,
    );

    final content = await Future.microtask(() {
      return DataProvider(
        clusterCount: widget.clusterCount,
        controller: _controller,
        buildHelper: _buildHelper,
        style: widget.style,
        initialPosition: StoryPosition(0, index),
        initialPositionStarted: ValueNotifier(false),
        hideBars: widget.hideBars,
        child: const ClusterView(),
      );
    });

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Stories',
      pageBuilder: (context, animation, secondaryAnimation) {
        return content;
      },
      transitionDuration: const Duration(milliseconds: 350),
      useRootNavigator: true,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;

        return SlideTransition(
          position: Tween(begin: begin, end: end).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.linearToEaseOut,
            ),
          ),
          child: child,
        );
      },
    );
  }

  Future<void> _handleTrayTap({
    required BuildContext context,
    required Widget tray,
    required int index,
  }) async {
    if (!_canShowCluster) return;
    _canShowCluster = false;

    if (tray is AnimationManager) {
      tray.notifier.notifyListeners(shouldAnimate: true);
    }

    await _show(
      context: context,
      index: index,
      manager: tray is AnimationManager ? tray : null,
    );

    _controller.notifyListeners(
      StoryEvent.trayTap,
      clusterIndex: index,
      storyIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: widget.style.trayStyle.padding,
      scrollDirection: widget.style.trayStyle.direction,
      itemCount: widget.clusterCount,
      itemBuilder: (context, index) {
        if (widget.buildClustersOnTrayScroll) {
          _buildHelper.prepareCluster(index);
        }

        Widget tray = widget.trayBuilder(index);

        if (tray is AnimatedTray) {
          tray = AnimationManager(
            notifier: AnimationNotifier(),
            child: tray,
          );
        }

        return GestureDetector(
          onTap: () => _handleTrayTap(
            context: context,
            tray: tray,
            index: index,
          ),
          child: tray,
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        width: widget.style.trayStyle.direction == Axis.vertical
            ? 0
            : widget.style.trayStyle.spacing,
        height: widget.style.trayStyle.direction == Axis.horizontal
            ? 0
            : widget.style.trayStyle.spacing,
      ),
    );
  }
}

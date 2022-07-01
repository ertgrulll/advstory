import 'dart:async';
import 'dart:ui';

import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/advstory_controller.dart';
import 'package:advstory/src/controller/advstory_controller_impl.dart';
import 'package:advstory/src/model/story.dart';
import 'package:advstory/src/model/style/advstory_style.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/util/position_notifier.dart';
import 'package:advstory/src/view/components/contents/simple_custom_content.dart';
import 'package:advstory/src/view/story_view.dart';
import 'package:advstory/src/view/components/tray/animated_tray.dart';
import 'package:advstory/src/view/components/tray/animation_manager.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An advanced story viewer for Flutter, designed for performance.
///
/// ___
/// _Quite easy & Quite advanced_
class AdvStory extends StatefulWidget {
  /// Creates a story tray list using [trayBuilder]. When a tray tapped calls
  /// [storyBuilder] and starts story flow.
  const AdvStory({
    required this.storyCount,
    required this.storyBuilder,
    required this.trayBuilder,
    this.controller,
    this.buildStoryOnTrayScroll = true,
    this.preloadStory = true,
    this.preloadContent = true,
    this.trayScrollController,
    this.style = const AdvStoryStyle(),
    Key? key,
  }) : super(key: key);

  /// Styles for the AdvStory.
  final AdvStoryStyle style;

  /// Provides methods for manipulating default story flow and listening events.
  final AdvStoryController? controller;

  /// The number of [Story]s to build and display.
  final int storyCount;

  /// Builds the [Story]s.
  ///
  /// This function can be async to provide lazy loading.
  final StoryBuilder storyBuilder;

  /// Builds a widget that shown in list for every story.
  /// Most probably story owner's profile picture.
  ///
  /// Each story must have a tray.
  final TrayBuilder trayBuilder;

  /// Sets whether stories are build when tray list is scrolled or the tray is
  /// tapped.
  ///
  /// Speeds up the opening time of story view when tray is tapped if this set
  /// to true but increases frequency of calling [storyBuilder]. If you are
  /// requesting data from server in [storyBuilder] you may want to set this
  /// to false to avoid rate limit.
  final bool buildStoryOnTrayScroll;

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
  final bool preloadStory;

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
  final bool preloadContent;

  final ScrollController? trayScrollController;

  @override
  State<AdvStory> createState() => _AdvStoryState();
}

class _AdvStoryState extends State<AdvStory> with TickerProviderStateMixin {
  late final AdvStoryControllerImpl _controller;
  late final _buildHelper = BuildHelper(storyBuilder: widget.storyBuilder);

  /// Used to determine whether a story can be shown or not.
  bool _canShowStory = true;

  /// Active progress indicator value controller.
  late final AnimationController _indicatorController;

  /// Controls indicator, header and footer visibility.
  late final AnimationController _opacityController;

  /// Controls story view position.
  late final AnimationController _posController;

  @override
  void initState() {
    super.initState();

    _setAnimationParams();
    _controller =
        (widget.controller ?? AdvStoryController()) as AdvStoryControllerImpl;
    _controller.setAnimationControllers(
      indicatorController: _indicatorController,
      opacityController: _opacityController,
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _indicatorController.dispose();
    _posController.dispose();

    super.dispose();
  }

  /// Sets values for animation controllers.
  void _setAnimationParams() {
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      value: 1.0,
    );
    _indicatorController = AnimationController(vsync: this);
    _posController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Opens story view and notifies listeners
  void _show(DataProvider view) async {
    _canShowStory = true;
    if (!mounted) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      barrierLabel: 'Stories',
      pageBuilder: (_, __, ___) => view,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.linearToEaseOut,
            ),
          ),
          child: child,
        );
      },
    );

    _controller.notifyListeners(
      StoryEvent.trayTap,
      storyIndex: view.positionNotifier.story,
      contentIndex: 0,
    );
  }

  Future<void> _handleTrayTap({
    required Widget tray,
    required int index,
  }) async {
    if (!_canShowStory) return;

    _posController.reset();
    _canShowStory = false;
    final positionNotifier = PositionNotifier(
      0,
      index,
      trayWillAnimate: tray is AnimationManager,
    );
    final firstContentPreperation =
        tray is AnimationManager ? Completer<void>() : null;

    final posAnim = Tween<Offset>(
      begin: Offset(
        0,
        (window.physicalSize / window.devicePixelRatio).height * 1.2,
      ),
      end: Offset.zero,
    ).animate(_posController);

    // Set story PageController to start from the given index.
    _controller.storyController = ExtendedPageController(
      initialPage: index,
      itemCount: widget.storyCount,
    );
    _controller.positionNotifier = positionNotifier;

    _show(
      DataProvider(
        controller: _controller,
        buildHelper: _buildHelper,
        style: widget.style,
        preloadStory: widget.preloadStory,
        preloadContent: widget.preloadContent,
        firstContentPreperation: firstContentPreperation,
        child: StoryView(positionAnimation: posAnim),
      ),
    );

    if (tray is AnimationManager) {
      tray.update(shouldAnimate: true);
      final story = await _buildHelper.buildStory(index);
      final content = story.contentBuilder(0);

      if (content is! SimpleCustomContent) {
        await firstContentPreperation!.future;
      }

      tray.update(shouldAnimate: false);
    }

    if (!mounted) return;
    if (widget.style.hideBars) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }

    _posController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      positionNotifier.update(status: StoryStatus.play);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller.trayScrollController,
      padding: widget.style.trayListStyle.padding,
      scrollDirection: widget.style.trayListStyle.direction,
      itemCount: widget.storyCount,
      itemBuilder: (context, index) {
        if (widget.buildStoryOnTrayScroll) {
          _buildHelper.prepareStory(index);
        }

        Widget tray = widget.trayBuilder(index);
        if (tray is AnimatedTray) {
          tray = AnimationManager(child: tray);
        }

        return GestureDetector(
          onTap: () => _handleTrayTap(
            tray: tray,
            index: index,
          ),
          child: tray,
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        width: widget.style.trayListStyle.direction == Axis.vertical
            ? 0
            : widget.style.trayListStyle.spacing,
        height: widget.style.trayListStyle.direction == Axis.horizontal
            ? 0
            : widget.style.trayListStyle.spacing,
      ),
    );
  }
}

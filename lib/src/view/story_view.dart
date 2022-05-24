import 'dart:ui';

import 'package:advstory/advstory.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:advstory/src/util/extensions.dart';
import 'package:advstory/src/view/components/story_indicator.dart';
import 'package:advstory/src/view/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Creates story view.
class StoryView extends StatefulWidget {
  /// Widget that displays the story, indicators, footer and header.
  const StoryView({
    required this.clusterIndex,
    required this.cluster,
    Key? key,
  }) : super(key: key);

  final int clusterIndex;
  final Cluster cluster;

  @override
  StoryViewState createState() => StoryViewState();
}

/// State for [StoryView].
class StoryViewState extends State<StoryView> {
  double get width => (window.physicalSize / window.devicePixelRatio).width;
  late final _pageController =
      ExtendedPageController(itemCount: widget.cluster.storyCount);
  late DataProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = DataProvider.of(context)!;
    _provider.controller
        .setStoryController(_pageController, widget.clusterIndex);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _provider.controller.cleanStoryController(widget.clusterIndex);
    super.dispose();
  }

  /// Skips to the next [Story] if touched position is in the right 23
  /// percent of screen.
  ///
  /// Skips to the previous [Story] if touched position is in the left 23
  /// percent of screen.
  void _handleTapUp(TapUpDetails event) {
    final x = event.globalPosition.dx;

    if (x > width * .77) {
      _provider.controller.toNextStory();
    } else if (x < width * .23) {
      _provider.controller.toPreviousStory();
    } else {
      _provider.controller.resume();
    }
  }

  /// Pause the story and unfocus if the user taps anywhere on the screen
  /// including footer and header areas.
  void _handleDownPress(_) {
    if (FocusManager.instance.primaryFocus != null) {
      // Close keyboard if opened.
      FocusManager.instance.primaryFocus?.unfocus();

      if (_provider.hideBars) {
        // Hide status bar and navigation bar. Keyboard causing show up.
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }

    _provider.controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onLongPressDown: _handleDownPress,
        onLongPressCancel: _provider.controller.resume,
        onLongPressUp: _provider.controller.resume,
        onLongPress: _provider.controller.exactPause,
        onTapUp: _handleTapUp,
        onVerticalDragEnd: (_) => Navigator.of(context).pop(),
        child: SafeArea(
          top: !_provider.hideBars,
          bottom: !_provider.hideBars,
          child: PageView.builder(
            allowImplicitScrolling: true,
            controller: _pageController,
            itemCount: widget.cluster.storyCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final story = widget.cluster.storyBuilder(index);
              final header = story.header ?? widget.cluster.header;
              final footer = story.footer ?? widget.cluster.footer;

              return Stack(
                children: [
                  story.asView(StoryPosition(index, widget.clusterIndex)),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      child: AnimatedBuilder(
                        animation: _provider.controller.opacityController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _provider.controller.opacityController,
                            child: child,
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              top: 0,
                              child: StoryIndicator(
                                activeIndicatorIndex: index,
                                count: widget.cluster.storyCount,
                                controller: _provider
                                    .controller.flowManager.indicatorController,
                                style: _provider.style.indicatorStyle,
                              ),
                            ),
                            if (header != null)
                              Positioned(
                                top: _provider.style.indicatorStyle.height + 16,
                                left: 0,
                                child: header,
                              ),
                            if (footer != null)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: footer,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

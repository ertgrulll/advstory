import 'dart:ui';

import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/model/story.dart';
import 'package:advstory/src/model/story_position.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:advstory/src/view/components/contents/simple_custom_content.dart';
import 'package:advstory/src/view/components/story_indicator.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:advstory/src/view/inherited_widgets/position_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// View for story contents. This widget uses a PageView to show story content
/// in a sequence.
class ContentView extends StatefulWidget {
  /// Creates a widget to display story, indicators, footer and header.
  const ContentView({
    required this.storyIndex,
    required this.story,
    Key? key,
  }) : super(key: key);

  /// Index of the story in the story list.
  final int storyIndex;

  /// Story that is being displayed in this view.
  final Story story;

  @override
  ContentViewState createState() => ContentViewState();
}

/// State for [ContentView].
class ContentViewState extends State<ContentView> {
  final _key = GlobalKey<ScaffoldState>();
  ExtendedPageController? _pageController;
  DataProvider? _provider;

  /// Returns width without using [MediaQuery].
  double get width => (window.physicalSize / window.devicePixelRatio).width;

  @override
  void didChangeDependencies() {
    _provider ??= DataProvider.of(context)!;
    final initialPage =
        _provider!.positionNotifier.initialPosition.story == widget.storyIndex
            ? _provider!.positionNotifier.content
            : 0;
    _pageController ??= ExtendedPageController(
      itemCount: widget.story.contentCount,
      initialPage: initialPage,
    );
    _provider!.controller
        .setContentController(_pageController!, widget.storyIndex);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _provider!.controller.cleanContentController(widget.storyIndex);
    super.dispose();
  }

  /// Skips to the next content if touched position is in the right 23
  /// percent of screen.
  ///
  /// Skips to the previous content if touched position is in the left 23
  /// percent of screen.
  void _handleTapUp(TapUpDetails event) {
    final viewWidth = _key.currentContext?.size?.width ?? width;
    final x = event.localPosition.dx;

    if (x > viewWidth * .77) {
      _provider!.controller.toNextContent();
    } else if (x < viewWidth * .23) {
      _provider!.controller.toPreviousContent();
    } else {
      _provider!.controller.resume();
    }
  }

  /// Pause the story and unfocus if the user taps anywhere on the screen
  /// including footer and header areas.
  void _handleDownPress(_) {
    // Close keyboard if opened.
    if (window.viewInsets.bottom > 0) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (_provider!.style.hideBars) {
        // Hide status bar and navigation bar. Keyboard causing show up.
        Future.delayed(const Duration(seconds: 1), () {
          SystemChrome.restoreSystemUIOverlays();
        });
      }
    }

    _provider!.controller.pause(innerCall: true);
  }

  List<Widget> _getComponents(AdvStoryContent content) {
    Widget? header;
    Widget? footer;

    if (content is SimpleCustomContent) {
      header = content.useStoryHeader ? widget.story.header : null;
      footer = content.useStoryFooter ? widget.story.footer : null;
    } else if (content is ManagedContent) {
      header = content.header ?? widget.story.header;
      footer = content.footer ?? widget.story.footer;
    }

    return [
      if (header != null)
        Positioned(
          top: _provider!.style.indicatorStyle.height + 16,
          left: 0,
          child: header,
        ),
      if (footer != null)
        Positioned(
          bottom: 0,
          left: 0,
          child: footer,
        ),
    ];
  }

  void _handleVerticalDrag(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      _provider!.controller.resume();
      return;
    }

    final interception = _provider!.controller.interceptor?.call(
      StoryEvent.close,
    );

    if (interception != null) {
      interception();
    } else {
      !_provider!.hasTrays
          ? _provider!.controller.positionNotifier.shouldShowView.value = false
          : Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onLongPressDown: _handleDownPress,
        onLongPressCancel: _provider!.controller.resume,
        onLongPressUp: _provider!.controller.resume,
        onLongPress: _provider!.controller.exactPause,
        onTapUp: _handleTapUp,
        onVerticalDragEnd: _handleVerticalDrag,
        child: PageView.builder(
          allowImplicitScrolling: _provider!.preloadContent,
          controller: _pageController,
          itemCount: widget.story.contentCount,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final content = widget.story.contentBuilder(index);

            return Stack(
              children: [
                PositionProvider(
                  position: StoryPosition(index, widget.storyIndex),
                  child: content,
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    top: _provider!.hasTrays,
                    bottom: _provider!.hasTrays,
                    child: FadeTransition(
                      opacity: _provider!.controller.opacityController,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          StoryIndicator(
                            activeIndicatorIndex: index,
                            count: widget.story.contentCount,
                            controller: _provider!
                                .controller.flowManager.indicatorController,
                            style: _provider!.style.indicatorStyle,
                          ),
                          ..._getComponents(content),
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
    );
  }
}

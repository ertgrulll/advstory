import 'dart:async';

import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:advstory/src/view/content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Creates a content group view.
class StoryView extends StatefulWidget {
  /// Creates a widget to managing [Story] skips using [PageView].
  const StoryView({Key? key}) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

/// State for [StoryView].
class _StoryViewState extends State<StoryView> {
  DataProvider? _provider;
  final _key = GlobalKey<ScaffoldState>();
  double _delta = 0;
  bool _isAnimating = false;
  bool _hasInterceptorCalled = false;
  StoryEvent? _event;
  FutureOr<void> Function()? _interception;

  @override
  void didChangeDependencies() {
    _provider ??= DataProvider.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _provider!.controller.notifyListeners(StoryEvent.close);
    if (_provider!.hasTrays && _provider!.style.hideBars) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder(
        valueListenable: _provider!.controller.gesturesDisabled,
        builder: (context, bool value, child) {
          return IgnorePointer(
            ignoring: value,
            child: child,
          );
        },
        child: GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          onHorizontalDragCancel: _resetParams,
          child: PageView.builder(
            allowImplicitScrolling: _provider!.preloadStory,
            physics: const NeverScrollableScrollPhysics(),
            pageSnapping: false,
            controller: _provider!.controller.storyController!,
            // Added one more page to detect when user swiped past
            // the last page
            itemBuilder: (context, index) {
              // If user swipes past the last page, return an empty view
              // before closing story view.
              if (index >= _provider!.controller.storyCount) {
                return const SizedBox();
              }

              final ValueNotifier<Widget> content =
                  ValueNotifier(_provider!.style());

              () async {
                final story = await _provider!.buildHelper.buildStory(index);

                content.value = ContentView(
                  storyIndex: index,
                  story: story,
                );
              }();

              return ValueListenableBuilder<Widget>(
                valueListenable: content,
                builder: (context, value, child) => value,
              );
            },
            onPageChanged: _handlePageChange,
          ),
        ),
      ),
    );
  }

  void _handlePageChange(int index) {
    // User reached to the last page, close story view.
    if (index == _provider!.controller.storyCount) {
      !_provider!.hasTrays
          ? _provider!.controller.positionNotifier.shouldShowView.value = false
          : Navigator.of(context).pop();
    } else {
      _provider!.controller.handleStoryChange(index);
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    final delta = details.primaryDelta!;
    final cont = _provider!.controller;
    final pageCont = cont.storyController!;

    if (!_hasInterceptorCalled) _callInterceptor(delta);

    if (_interception == null) {
      // Prevent right scroll on first story
      if (pageCont.page!.round() == 0 && delta > 0) {
        cont.resume();

        return;
      }

      _delta += delta;
      pageCont.jumpTo(-delta + pageCont.position.pixels);
      final width = _key.currentContext!.size!.width;
      if (_delta.abs() < width * .2) cont.resume();
    } else if (_event == StoryEvent.close) {
      _interception!();
    } else {
      cont.resume();
    }
  }

  void _callInterceptor(double delta) {
    final cont = _provider!.controller;

    if (cont.storyController!.page!.round() == cont.storyCount - 1 &&
        delta < 0) {
      _event = StoryEvent.close;
    } else {
      _event = delta < 0 ? StoryEvent.nextStory : StoryEvent.previousStory;
    }
    _interception = cont.interceptor?.call(_event!);

    _hasInterceptorCalled = true;
  }

  void _handleDragEnd(_) {
    if (_interception == null) {
      final cont = _provider!.controller.storyController!;
      final width = _key.currentContext!.size!.width;
      final bound = _delta.abs() > width * .2;

      final addition = _delta < 0 ? 1 : -1;
      final contPage = cont.page!.round();
      final page =
          _delta.abs() < width * .5 && bound ? contPage + addition : contPage;

      _isAnimating = true;
      const duration = Duration(milliseconds: 300);
      cont.animateToPage(page, curve: Curves.ease, duration: duration);
      Future.delayed(duration, () {
        _delta = 0;
        _isAnimating = false;
      });
    } else {
      _interception!();
    }

    _resetParams();
  }

  void _resetParams() {
    _delta = 0;
    _hasInterceptorCalled = false;
    _event = null;
    _interception = null;
  }
}

import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/async_page_view.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:advstory/src/view/content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Creates a content group view.
class StoryView extends StatefulWidget {
  /// Creates a widget to managing [Story] skips using [PageView].
  const StoryView({
    required this.positionAnimation,
    Key? key,
  }) : super(key: key);

  /// Animation of the view. [StoryView] position is controlled by parent
  /// according to the tray type and media load status.
  final Animation<Offset> positionAnimation;

  @override
  State<StoryView> createState() => _StoryViewState();
}

/// State for [StoryView].
class _StoryViewState extends State<StoryView> {
  DataProvider? _provider;

  @override
  void didChangeDependencies() {
    _provider ??= DataProvider.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_provider!.style.hideBars) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    _provider!.controller.notifyListeners(StoryEvent.close);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: widget.positionAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: widget.positionAnimation,
            child: child,
          );
        },
        child: ValueListenableBuilder(
          valueListenable: _provider!.controller.gesturesDisabled,
          builder: (context, bool value, child) {
            return IgnorePointer(
              ignoring: value,
              child: child,
            );
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              if (_provider!.controller.storyController!.page == 0) {
                notification.disallowIndicator();
                _provider!.controller.resume();

                return true;
              }

              return false;
            },
            child: AsyncPageView(
              allowImplicitScrolling: _provider!.preloadStory,
              controller: _provider!.controller.storyController!,
              loadingScreen: _provider!.style(),
              // Added one more page to detect when user swiped past the last page
              itemCount: _provider!.controller.storyCount + 1,
              itemBuilder: (context, index) async {
                // If user swipes past the last page, return an empty view before
                // closing story view.
                if (index == _provider!.controller.storyCount) {
                  return const SizedBox();
                }
                final story = await _provider!.buildHelper.buildStory(index);

                return ContentView(
                  storyIndex: index,
                  story: story,
                );
              },
              onPageChanged: (index) {
                // User reached to the last page, close story view.
                if (index == _provider!.controller.storyCount) {
                  Navigator.of(context).pop();
                } else {
                  _provider!.controller.handleStoryChange(index);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

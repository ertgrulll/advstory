import 'dart:async';
import 'dart:io';

import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/advstory_controller.dart';
import 'package:advstory/src/controller/flow_manager.dart';
import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:advstory/src/util/position_notifier.dart';

const String _navigationExc = "Couldn't navigate, story view is not visible.";

/// Implementation of [AdvStoryController].
class AdvStoryControllerImpl implements AdvStoryController {
  /// Creates an instance of [AdvStoryControllerImpl].
  AdvStoryControllerImpl() {
    flowManager = FlowManager(callback: toNextContent);
  }

  /// Position of the current story. [PositionNotifier] also contains a
  /// variable to keep story state, this variable is used to pause/resume story.
  final positionNotifier = PositionNotifier();

  /// Manages cronometer and indicators of story.
  late final FlowManager flowManager;

  /// Count of the stories.
  int? _storyCount;

  /// Event listeners for [AdvStoryController]
  final _listeners = ObserverList<StoryEventCallback>();

  /// Controls whether user can interact with story view or not.
  final ValueNotifier<bool> gesturesDisabled = ValueNotifier(false);

  /// Used to determine if gestures disabled by the developer or automatically.
  ///
  /// Gestures disabling before switching story due to prevent user interaction.
  bool _isGesturesDisabledManually = false;

  /// Used to determine if user paused the story by long pressing the screen.
  /// Stories also pausing while user swiping to the next story.
  bool _isExactPause = false;

  /// Story pageview controller. This controller lets controller to skip next
  /// and previous story.
  PageController? storyController;

  /// Active content pageview controller. This controller lets to skip next and
  /// previous content.
  ExtendedPageController? get contentController =>
      _contentControllers[storyIndex];

  /// Keeps controllers until related content is removed from widget tree.
  final _contentControllers = <int, ExtendedPageController>{};

  /// Controls footer, header and indicator visibility in the story view.
  late AnimationController opacityController;

  /// Sets story count, used to determine bounds.
  set storyCount(int count) => _storyCount = count;

  /// Function to call before story events except [StoryEvent.trayTap].
  Interceptor? interceptor;

  /// Function to call before [StoryEvent.trayTap] event.
  TrayTapInterceptor? trayTapInterceptor;

  @override
  int get storyCount => _storyCount ?? 0;

  @override
  bool get hasClient => storyController?.hasClients ?? false;

  @override
  int get contentCount => contentController?.itemCount ?? 0;

  @override
  bool get isGesturesDisabled => gesturesDisabled.value;

  @override
  bool get isComponentsVisible => opacityController.value == 1.0;

  @override
  bool get isPaused => !flowManager.isRunning;

  @override
  StoryPosition get position => StoryPosition(contentIndex, storyIndex);

  @override
  void hideComponents() => opacityController.animateTo(0.0);

  @override
  void showComponents() => opacityController.animateTo(1.0);

  @override
  void toNextContent() {
    assert(hasClient, _navigationExc);
    final interception = interceptor?.call(StoryEvent.nextContent);
    if (interception != null) {
      interception();
      return;
    }

    // Reached to the last content, skip to next story.
    if (contentIndex == contentCount - 1) {
      toNextStory();
    } else {
      final nextIndex = contentIndex + 1;

      flowManager.reset();
      contentController!.jumpToPage(nextIndex);
      positionNotifier.update(content: nextIndex);
      notifyListeners(StoryEvent.nextContent);
    }
  }

  @override
  void toPreviousContent() {
    assert(hasClient, _navigationExc);
    final interception = interceptor?.call(StoryEvent.previousContent);
    if (interception != null) {
      interception();
      return;
    }

    // Displaying first content, skip to previous story.
    if (contentIndex == 0) {
      toPreviousStory();
    } else {
      final previousIndex = contentIndex - 1;

      flowManager.reset();
      contentController!.jumpToPage(previousIndex);
      positionNotifier.update(content: previousIndex);
      notifyListeners(StoryEvent.previousContent);
    }
  }

  @override
  void pause({bool innerCall = false}) {
    assert(hasClient, "Couldn't pause, story view is not visible.");
    if (!flowManager.isRunning) return;

    if (!innerCall) {
      final interception = interceptor?.call(StoryEvent.pause);
      if (interception != null) {
        interception();
        resume();
        return;
      }
    }

    // Stop timer to prevent skipping to next media
    flowManager.pause();
    positionNotifier.update(status: StoryStatus.pause);

    if (!innerCall) {
      _isExactPause = true;
      notifyListeners(StoryEvent.pause);
    }
  }

  /// Called when the tap is a long press.
  ///
  /// Hides widgets over the [AdvStoryContent] and notifies listeners.
  void exactPause() {
    final interception = interceptor?.call(StoryEvent.pause);
    if (interception != null) {
      interception();
      resume();
      return;
    }
    _isExactPause = true;

    // This is done here instead of pause method to prevent hiding on skips
    // or on short taps.
    hideComponents();
    notifyListeners(StoryEvent.pause);
  }

  @override
  void resume() {
    assert(hasClient, "Couldn't resume, story view is not visible.");
    if (flowManager.isRunning) return;
    final interception = interceptor?.call(StoryEvent.resume);
    if (interception != null) {
      interception();
      return;
    }

    showComponents();
    flowManager.resume();
    positionNotifier.update(status: StoryStatus.resume);
    if (_isExactPause) notifyListeners(StoryEvent.resume);
    _isExactPause = false;
  }

  @override
  void addListener(StoryEventCallback listener) => _listeners.add(listener);

  @override
  void removeListener(StoryEventCallback listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }

  @override
  void disableGestures() {
    _isGesturesDisabledManually = true;
    gesturesDisabled.value = true;
  }

  @override
  void enableGestures() {
    _isGesturesDisabledManually = false;
    gesturesDisabled.value = false;
  }

  @override
  void toNextStory() {
    assert(hasClient, _navigationExc);
    final interception = interceptor?.call(StoryEvent.nextStory);
    if (interception != null) {
      interception();
      return;
    }

    int ms = 500;

    if (storyIndex < storyCount - 1) {
      // Disable gestures to prevent user from tapping on the screen while page
      // is animating
      gesturesDisabled.value = true;
      ms = 250;
    } else {
      final interception = interceptor?.call(StoryEvent.close);

      if (interception != null) {
        interception();

        return;
      }
    }

    flowManager.reset();

    storyController!.nextPage(
      duration: Duration(milliseconds: ms),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  void toPreviousStory() {
    assert(hasClient, _navigationExc);
    final interception = interceptor?.call(StoryEvent.previousStory);
    if (interception != null) {
      interception();
      return;
    }

    if (storyIndex > 0) {
      flowManager.reset();

      // Disable gestures to prevent user from tapping on the screen while page
      // is animating
      gesturesDisabled.value = true;

      storyController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    } else {
      resume();
    }
  }

  @override
  Future<File> preloadMediaFile({
    required String url,
    String? cacheKey,
    Map<String, String>? requestHeaders,
  }) async {
    return await BuildHelper().getMediaFile(
      url: url,
      requestHeaders: requestHeaders,
      cacheKey: cacheKey,
    );
  }

  @override
  void setInterceptor(Interceptor interceptor) =>
      this.interceptor = interceptor;

  @override
  void removeInterceptor() => interceptor = null;

  @override
  void setTrayTapInterceptor(TrayTapInterceptor interceptor) =>
      trayTapInterceptor = interceptor;

  @override
  void removeTrayTapInterceptor() => trayTapInterceptor = null;

  @override
  Future<void> jumpTo({required int story, required int content}) async {
    storyController?.hasClients == false
        ? SchedulerBinding.instance.addPostFrameCallback(
            (_) => _jump(story, content),
          )
        : _jump(story, content);
  }

  Future<void> _jump(int story, int content) async {
    assert(hasClient, _navigationExc);
    assert(
      story >= 0 && story < storyCount,
      "Story index out of range!",
    );
    assert(content >= 0, "Content index out of range!");
    flowManager.reset();

    void _listener() {
      if (storyController!.page!.floor() == story) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
          await _waitContentController(story);

          assert(
            contentController!.itemCount > content,
            "Content index out of range.",
          );

          contentController!.jumpToPage(content);
          positionNotifier.update(content: content, story: story);
        });

        storyController!.removeListener(_listener);
      }
    }

    if (storyIndex == story) {
      await _waitContentController(story);
      contentController!.jumpToPage(content);
      positionNotifier.update(content: content);
    } else {
      storyController!.addListener(_listener);
      storyController!.jumpToPage(story);
    }
  }

  /// Waits for the PageController of the given index to be assigned.
  ///
  /// [jumpTo] method calls this method to wait for the PageController of the
  /// given index to be assigned. This prevents jumping to content before the
  /// pageview is not created.
  Future<void> _waitContentController(index) async {
    if (_contentControllers[index] != null) return;

    final completer = Completer<void>();

    Timer.periodic(
      const Duration(milliseconds: 25),
      (timer) {
        if (_contentControllers[index] != null) {
          completer.complete();
          timer.cancel();
        }
      },
    );

    return completer.future;
  }

  /// Currently displaying story index.
  int get storyIndex => storyController?.page?.round() ?? 0;

  /// Currently displaying content index in the current story.
  int get contentIndex => contentController?.page?.round() ?? 0;

  /// Sets animation controllers to use controlling the opacity of the header,
  /// footer and indicator and active indicator progress.
  void setAnimationControllers({
    required AnimationController opacityController,
    required AnimationController indicatorController,
  }) {
    this.opacityController = opacityController;
    flowManager.indicatorController = indicatorController;
  }

  /// Adds content PageViewController to controllers.
  void setContentController(ExtendedPageController controller, int index) {
    _contentControllers[index] = controller;
  }

  /// Returns content page view controller by index.
  ExtendedPageController? getContentController(int index) {
    return _contentControllers[index];
  }

  /// Removes content PageViewController to controllers.
  void cleanContentController(int index) {
    _contentControllers.remove(index)?.dispose();
  }

  /// Starts flow for the current story's first item.
  void handleStoryChange(int index) {
    flowManager.reset();

    // If current page is last page, do nothing.
    if (index > storyCount - 1) return;

    // Check gestures disabled by package user, if not re-enable.
    // Gestures disabling while user swiping the story to prevent unnecessary
    // executions of gesture handlers.
    if (!_isGesturesDisabledManually) {
      gesturesDisabled.value = false;
    }

    final event = positionNotifier.content < contentIndex
        ? StoryEvent.nextStory
        : StoryEvent.previousStory;

    positionNotifier.update(content: contentIndex, story: storyIndex);
    notifyListeners(event);
  }

  /// Resets values of controller, values are only available to current view.
  void _reset() {
    flowManager.reset();
    positionNotifier.reset();
    _isExactPause = false;
    _isGesturesDisabledManually = false;
    gesturesDisabled.value = false;
    opacityController.value = 1;

    storyController?.dispose();
    storyController = null;
  }

  /// Calls registered listeners
  void notifyListeners(
    StoryEvent event, {
    int? storyIndex,
    int? contentIndex,
  }) {
    if (event == StoryEvent.close) {
      _reset();
    }

    for (final listener in _listeners) {
      listener.call(
        event,
        StoryPosition(
          contentIndex ?? this.contentIndex,
          storyIndex ?? this.storyIndex,
        ),
      );
    }
  }
}

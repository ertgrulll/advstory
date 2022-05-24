import 'package:advstory/advstory.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/flow_manager.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Implementation of [AdvStoryController]
class AdvStoryControllerImpl implements AdvStoryController {
  AdvStoryControllerImpl({Duration duration = const Duration(seconds: 10)}) {
    flowManager = FlowManager(
      duration: duration,
      callback: toNextStory,
    );
  }

  /// Manages cronometer and indicators of story.
  late final FlowManager flowManager;

  /// Event listeners for [AdvStoryController]
  final _listeners = ObserverList<StoryEventCallback>();

  /// Controls if user can interact with story view.
  final ValueNotifier<bool> gesturesDisabled = ValueNotifier(false);

  /// Used to determine if gestures disabled by the package user.
  ///
  /// Gestures disabling automatically while switching cluster due to
  /// prevent user interaction with the story.
  bool _isGesturesDisabledManually = false;

  /// Cluster's pageview controller. This controller used to skipping to the
  /// next or previous cluster.
  ExtendedPageController? clusterController;

  /// Controls story view, used to skipping to the next or previous story.
  ExtendedPageController? get storyController =>
      _storyControllers[clusterIndex];

  /// Keeps controllers until related cluster is removed.
  final _storyControllers = <int, ExtendedPageController>{};

  /// Controls component visibility in the story view.
  late AnimationController opacityController;

  /// Used to determine if user paused the story by long pressing the screen.
  /// Stories also pausing while user swiping to the next cluster.
  bool _isExactPause = false;

  @override
  bool get hasClient => clusterController?.hasClients ?? false;

  @override
  int get clusterIndex => clusterController?.page?.round() ?? 0;

  @override
  int get storyIndex => storyController?.page?.round() ?? 0;

  int get clusterCount => clusterController?.itemCount ?? 0;

  @override
  int get storyCount => storyController?.itemCount ?? 0;

  @override
  bool get isGesturesDisabled => gesturesDisabled.value;

  @override
  bool get isComponentsVisible => opacityController.value == 1.0;

  @override
  void hideComponents() => opacityController.animateTo(0.0);

  @override
  void showComponents() => opacityController.animateTo(1.0);

  @override
  void setVolume(double level) => flowManager.videoController?.setVolume(level);

  @override
  void toNextStory() {
    assert(hasClient, "Couldn't navigate, story view is not visible.");
    // Reached to the last media.
    if (storyIndex == storyCount - 1) {
      toNextCluster();
    } else {
      final nextIndex = storyIndex + 1;
      storyController!.jumpToPage(nextIndex);
      flowManager.start(StoryPosition(nextIndex, clusterIndex));

      notifyListeners(StoryEvent.storySkip);
    }
  }

  @override
  void toPreviousStory() {
    assert(hasClient, "Couldn't navigate, story view is not visible.");

    // Displaying first media, skip to previous cluster.
    if (storyIndex == 0) {
      toPreviousCluster();
    } else {
      final previousIndex = storyIndex - 1;
      storyController!.jumpToPage(previousIndex);
      flowManager.start(StoryPosition(previousIndex, clusterIndex));

      notifyListeners(StoryEvent.storySkip);
    }
  }

  @override
  void pause() {
    assert(hasClient, "Couldn't pause, story view is not visible.");

    if (!flowManager.isRunning) return;

    // Stop timer to prevent skipping to next media
    flowManager.pause();
  }

  /// Called when the tap is a long press.
  ///
  /// Hides widgets over the [Story] and notifies listeners.
  void exactPause() {
    _isExactPause = true;

    // This is done here instead of pause method to prevent hiding on skip
    // or on short taps.
    hideComponents();

    // Notify listeners about pause
    notifyListeners(StoryEvent.pause);
  }

  @override
  void resume() {
    assert(hasClient, "Couldn't resume, story view is not visible.");
    if (flowManager.isRunning) return;

    showComponents();
    flowManager.resume();

    if (_isExactPause) {
      notifyListeners(StoryEvent.resume);
    }
    // Reset exact pause flag
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
  void jumpTo(int clusterIndex, int storyIndex) {
    assert(hasClient, "Couldn't navigate, story view is not visible.");
    assert(clusterIndex >= 0 && clusterIndex < clusterCount);
    assert(storyIndex >= 0);
    flowManager.reset();

    void _listener() {
      if (clusterController!.page!.round() == clusterIndex) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          storyController?.jumpToPage(storyIndex);
          flowManager.start(StoryPosition(storyIndex, clusterIndex));
        });

        clusterController!.removeListener(_listener);
      }
    }

    if (this.clusterIndex == clusterIndex) {
      storyController!.jumpToPage(storyIndex);
      flowManager.start(StoryPosition(storyIndex, clusterIndex));
    } else {
      clusterController!.addListener(_listener);
      clusterController!.jumpToPage(clusterIndex);
    }
  }

  @override
  void toNextCluster() {
    assert(hasClient, "Couldn't navigate, cluster view is not visible.");
    flowManager.reset();

    int ms = 500;

    if (clusterIndex < clusterCount - 1) {
      // Disable gestures to prevent user from tapping on the screen while page
      // is animating
      gesturesDisabled.value = true;
      ms = 250;
    }

    clusterController!.nextPage(
      duration: Duration(milliseconds: ms),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  void toPreviousCluster() {
    assert(hasClient, "Couldn't navigate, cluster view is not visible.");
    if (clusterIndex > 0) {
      flowManager.reset();

      // Disable gestures to prevent user from tapping on the screen while page
      // is animating
      gesturesDisabled.value = true;

      clusterController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    } else {
      resume();
    }
  }

  @override
  Future<void> preloadMediaFile({
    required String url,
    String? cacheKey,
    Map<String, String>? requestHeaders,
  }) async {
    await BuildHelper().getMediaFile(
      url: url,
      headers: requestHeaders,
      key: cacheKey,
    );
  }

  void initialize({
    required AnimationController opacityController,
    required AnimationController indicatorController,
  }) {
    this.opacityController = opacityController;
    flowManager.indicatorController = indicatorController;
  }

  void setStoryController(ExtendedPageController controller, int index) {
    _storyControllers[index] = controller;
  }

  void cleanStoryController(int index) {
    _storyControllers.remove(index)?.dispose();
  }

  /// Starts flow for the current cluster.
  void handleClusterChange(int index) {
    flowManager.reset();

    // If current page is last page, do nothing.
    if (index > clusterCount - 1) return;

    // Check gestures disabled by package user, if not re-enable.
    // Gestures disabling while user swiping the cluster to prevent unnecessary
    // executions of gesture handlers.
    if (!_isGesturesDisabledManually) {
      gesturesDisabled.value = false;
    }

    flowManager.start(StoryPosition(storyIndex, clusterIndex));
    notifyListeners(StoryEvent.clusterSkip);
  }

  /// Resets values of controller, values are only available to current view.
  void _reset() {
    flowManager.reset();
    _isExactPause = false;
    _isGesturesDisabledManually = false;
    gesturesDisabled.value = false;
    opacityController.value = 1;

    clusterController?.dispose();
    clusterController = null;
  }

  /// Calls registered listeners
  @pragma('vm:notify-debugger-on-exception')
  void notifyListeners(
    StoryEvent event, {
    int? clusterIndex,
    int? storyIndex,
  }) {
    if (event == StoryEvent.close) {
      _reset();
    }

    for (final listener in _listeners) {
      listener.call(
        event,
        StoryPosition(
          storyIndex ?? this.storyIndex,
          clusterIndex ?? this.clusterIndex,
        ),
      );
    }
  }
}

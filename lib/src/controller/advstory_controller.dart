import 'package:advstory/advstory.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/story_controller_impl.dart';

/// Base class for controlling [AdvStory].
abstract class AdvStoryController {
  /// Provides methods for manipulating [AdvStory] default flow and listening
  /// events.
  ///
  /// Default story skip duration is 10 seconds for image and widget
  /// stories, video duration for video stories. [duration] only affects image
  /// and widget stories.
  factory AdvStoryController({Duration duration}) = AdvStoryControllerImpl;

  /// Currently displaying story index in the current cluster.
  int get storyIndex;

  /// Returns true if a cluster view is currently visible. Some methods like
  /// [toNextStory], [toPreviousCluster] can't be used and throws an exception
  /// if the cluster is not visible.
  bool get hasClient;

  /// Currently displaying cluster index.
  int? get clusterIndex;

  /// Total story count in currently displaying cluster.
  int? get storyCount;

  /// If gestures are disabled returns true, otherwise false.
  bool get isGesturesDisabled;

  /// Returns true if footer, header and indicators are visible, false
  /// otherwise.
  bool get isComponentsVisible;

  /// Jumps to the [storyIndex] in cluster [clusterIndex].
  ///
  /// Throws an exception if one of the indexes is not valid. Cluster's
  /// building lazily, no way to know story count before building. Ensure that
  /// cluster has enough stories to jump to the [storyIndex] before try to jump.
  void jumpTo(int clusterIndex, int storyIndex);

  /// Skips to the next cluster if available. Otherwise closes the story view.
  void toNextCluster();

  /// Skips to the previous cluster if available. Otherwise does nothing.
  void toPreviousCluster();

  /// Skips to the next story if available. Otherwise skips to the next cluster
  /// or closes the story view.
  void toNextStory();

  /// Skips to previous story if available. Otherwise skips to the previous
  /// cluster or does nothing.
  void toPreviousStory();

  /// Shows header, footer and story indicator
  void showComponents();

  /// Hides header, footer and story indicator
  void hideComponents();

  /// Pauses the current story, this stops the timer and the story will not
  /// advance to the next item.
  ///
  /// Pauses the video if current story is a [VideoStory].
  void pause();

  /// Resumes the current story, this starts the timer from last position
  /// and the story will advances as usual.
  ///
  /// Resumes the video if current story is a [VideoStory].
  void resume();

  /// Prevents gesture events.
  ///
  /// This causes to user to be unable to swiping the cluster, moving to the
  /// next or previous story, pausing, resuming and closing the view.
  /// Android back button remains available for closing.
  /// Automatic skipping still works on story duration end.
  ///
  /// ***Gestures should enable by calling [enableGestures] after
  /// calling this method. Otherwise user cannot use gestures anymore.***
  void disableGestures();

  /// Allows gesture events if disabled.
  void enableGestures();

  /// Adds a listener callback for events.
  ///
  /// Called when:
  /// * A story is skipped
  /// * A story is paused by long pressing to screen or played by
  /// releasing press.
  /// * A tray is tapped.
  /// * A cluster is skipped or closed.
  ///
  /// _Events may be triggered by user or automatically._
  ///
  /// **Listener parameters:**
  /// 1. Type of the event.
  /// 2. Position of the currently displaying cluster and story.
  void addListener(StoryEventCallback callback);

  /// Removes a listener. Call this method when you don't need to listen events
  /// anymore.
  void removeListener(StoryEventCallback listener);

  /// Sets volume level for [VideoStory]. This only affects currently playing
  /// video. If story is not a video, this method does nothing.
  void setVolume(double level);

  /// Useful when you want to extend [AdvStory] media load strategy.
  ///
  /// By default, [AdvStory] loads media in the background before 2 story.
  /// For example when user starts to display first story, third story media
  /// file starts loading.
  Future<void> preloadMediaFile({
    required String url,
    String? cacheKey,
    Map<String, String>? requestHeaders,
  });
}

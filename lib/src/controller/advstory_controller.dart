import 'dart:io';

import 'package:advstory/src/advstory.dart';
import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/controller/advstory_controller_impl.dart';
import 'package:advstory/src/model/story_position.dart';
import 'package:advstory/src/view/components/contents/video_content.dart';

/// {@macro advstory.storyController}
abstract class AdvStoryController {
  /// Creates an AdvStoryController.
  ///
  /// Check [hasClient] before calling methods.
  factory AdvStoryController() = AdvStoryControllerImpl;

  /// Returns true if a story view is currently visible. Most methods like
  /// [toNextContent], [toPreviousStory] can't be used and throws an exception
  /// if the story view is not visible.
  bool get hasClient;

  /// Displaying story and content position. Returns `0,0` if no story is
  /// currently displayed.
  StoryPosition get position;

  /// Total count of stories.
  int get storyCount;

  /// Total content count in currently displaying story.
  int get contentCount;

  /// If gestures are disabled returns true, otherwise false.
  bool get isGesturesDisabled;

  /// Returns true if footer, header and indicators are visible, false
  /// otherwise.
  bool get isComponentsVisible;

  /// Returns true if the story is paused, false otherwise.
  bool get isPaused;

  /// Jumps to the [content] in story [story].
  ///
  /// Throws an exception if one of the indexes is out of range. Ensure that
  /// story has enough content to jump to the [content] before try to jump.
  void jumpTo({required int story, required int content});

  /// Skips to the next story if available. Otherwise closes the story view.
  ///
  /// See also:
  /// * [toPreviousStory], which skips to the previous story.
  /// * [toNextContent], which skips to the next content.
  void toNextStory();

  /// Skips to the previous story if available. Otherwise does nothing.
  ///
  /// See also:
  /// * [toNextStory], which skips to the next story.
  /// * [toPreviousContent], which skips to the previous content.
  void toPreviousStory();

  /// Skips to the next content if available. Otherwise skips to the next story
  /// or closes the story view.
  ///
  /// See also:
  /// * [toPreviousContent], which skips to the previous content.
  /// * [toNextStory], which skips to the next story.
  void toNextContent();

  /// Skips to previous content if available. Otherwise skips to the previous
  /// story or does nothing.
  ///
  /// See also:
  /// * [toNextContent], which skips to the next content.
  /// * [toPreviousStory], which skips to the previous story.
  void toPreviousContent();

  /// Shows header, footer and story indicator.
  ///
  /// See also:
  ///  * [hideComponents], which hides shown header, footer and story indicator.
  void showComponents();

  /// Hides header, footer and story indicator. When gestures didn't disabled
  /// user can show them by tapping screen.
  ///
  /// See also:
  /// * [showComponents], which shows previously hidden header, footer and
  /// story indicator.
  void hideComponents();

  /// Pauses the current story, this stops the timer and the story will not
  /// skip to the next item. This method doesn't hide header, footer and
  /// indicator after pause.
  ///
  /// Pauses the video if current story is a [VideoContent].
  ///
  /// See also:
  ///
  ///  * [resume], which resumes the story from the paused state.
  ///  * [hideComponents], which hides header, footer and indicator.
  ///  * [isPaused], which returns true if the story is paused.
  void pause();

  /// Resumes the current story, starts the timer and indicator from last
  /// position and story skips as usual.
  ///
  /// Resumes the video if current story is a [VideoContent].
  ///
  /// /// See also:
  ///
  ///  * [pause], which resumes the story from the paused state.
  void resume();

  /// Prevents gesture events.
  ///
  /// This causes to user to be unable to swiping the story, skipping to the
  /// next or previous content, pausing, resuming and closing the view.
  ///
  /// Note that:
  /// * _Android back button still works for closing._
  /// * _Automatic skipping still works on story duration end. If you want to
  /// prevent this, use combination of [disableGestures] and [pause]_
  ///
  /// Gestures should enable by calling [enableGestures] after calling this
  /// method. Otherwise AdvStory doesn't responds gestures anymore.
  ///
  /// See also:
  ///
  ///  * [enableGestures], which enables if gestures previously disabled.
  void disableGestures();

  /// Allows gesture events.
  ///
  /// See also:
  ///
  ///  * [disableGestures], which disables gestures if previously enabled.
  void enableGestures();

  /// Register a closure to be called when any story event happens.
  ///
  /// Called when:
  /// * a content is skipped,
  /// * a content is paused
  /// * a tray is tapped.
  /// * a story is skipped
  /// * story view closed.
  ///
  /// _Events may be triggered by user or automatically._
  ///
  /// **Listener parameters:**
  /// 1. Type of the event.
  /// 2. Position of the currently displaying story and content.
  ///
  /// See also:
  ///
  ///  * [removeListener], which removes a previously registered closure from
  ///    the list of closures that are notified when the object changes.
  void addListener(StoryEventCallback callback);

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  ///
  /// If the given listener is not registered, the call is ignored.
  /// Call this method when you don't need to listen events anymore.
  void removeListener(StoryEventCallback listener);

  /// Useful when you want to extend [AdvStory] media load strategy.
  ///
  /// By default, [AdvStory] loads previous and next contents media in the
  /// background.
  Future<File> preloadMediaFile({
    required String url,
    String? cacheKey,
    Map<String, String>? requestHeaders,
  });

  /// Registers a function to intercept and replace default story event
  /// actions except [StoryEvent.trayTap].
  ///
  /// See [setTrayTapInterceptor] for [StoryEvent.trayTap] event.
  ///
  /// AdvStory calls interceptor function before story events and uses result
  /// instead of default action.
  /// Return null to allow default event action.
  ///
  /// For example, you can use an interceptor to prevent content skipping and
  /// jump to another content based on story position.
  ///
  /// ```dart
  /// final _controller = AdvStoryController();
  /// _controller.setInterceptor((event) {
  ///   if(event == StoryEvent.nextContent) {
  ///     return () => print('StoryEvent.nextContent blocked.');
  ///   }
  ///
  ///   return null;
  /// });
  ///
  /// ```
  ///
  /// See also:
  ///
  /// [removeInterceptor] to remove registered interceptor.
  void setInterceptor(Interceptor interceptor);

  /// Clears previously registered interceptor.
  ///
  /// See also:
  ///
  /// [setInterceptor] to register an interceptor.
  void removeInterceptor();

  /// Registers a function to intercept and replace default tray tap event
  /// action.
  ///
  /// When a tray tapped, AdvStory calls this method before open story view,
  /// return a story position to change opening position or return null to
  /// open at content 0 of the tapped tray.
  ///
  /// See also:
  ///
  /// [removeTrayTapInterceptor]
  void setTrayTapInterceptor(TrayTapInterceptor interceptor);

  /// Clears previously registered tray tap interceptor.
  ///
  /// See also:
  ///
  /// [setTrayTapInterceptor] to register an interceptor.
  void removeTrayTapInterceptor();
}

/// Event types
enum StoryEvent {
  /// Tapped on a story tray
  trayTap,

  /// Swiped to the next or previous story by the user or automatically skipped.
  storySkip,

  /// Skipped to the next or previous content by the user or automatically
  contentSkip,

  /// Long pressed to pause the story or called `pause()`.
  pause,

  /// Released long press to resume the story or called `resume()`.
  resume,

  /// Swiped down to close the story view or has reached to the end of the
  /// stories.
  close,
}

/// Status types of a story
enum StoryStatus {
  /// Story is playing
  play,

  /// Story is paused
  pause,

  /// Story is skipped
  stop,

  /// Story is resumed
  resume,
}

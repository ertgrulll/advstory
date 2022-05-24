/// Event types
enum StoryEvent {
  /// The user has tapped on a cluster tray
  trayTap,

  /// Swiped to the next or previous cluster by the user or automatically
  clusterSkip,

  /// Skipped to the next or previous story by the user or automatically
  storySkip,

  /// The user has tapped on a story to pause the story
  pause,

  /// The user has cancelled tap to resume the story
  resume,

  /// The user has swiped down to close the story view or has reached to
  /// the end of the stories.
  close,
}

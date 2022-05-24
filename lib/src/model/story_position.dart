/// Position of the story.
///
/// This class is equatable, you can compare postions using == operator.
class StoryPosition {
  StoryPosition(this.story, this.cluster);

  /// Index of currently displaying story in cluster.
  final int story;

  /// Index of currently displaying cluster.
  final int cluster;

  @override
  bool operator ==(Object other) =>
      other is StoryPosition &&
      story == other.story &&
      cluster == other.cluster;

  @override
  int get hashCode => Object.hash(story, cluster);
}

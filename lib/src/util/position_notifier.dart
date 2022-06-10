import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';
import 'package:advstory/src/contants/enums.dart';

/// This class provides information about story view position, story status and
/// tray animation status to the contents. Contents listens this to set their
/// state.
///
/// [AdvStoryController] updates position and status to notify contents.
class PositionNotifier extends ChangeNotifier implements StoryPosition {
  /// Creates a new story position.
  factory PositionNotifier(int content, int story, {bool? trayWillAnimate}) =>
      PositionNotifier._(content, story, trayWillAnimate ?? false);

  PositionNotifier._(this._content, this._story, this.trayWillAnimate)
      : initialContentPosition = _content,
        initialStoryPosition = _story;

  /// Story view opening story position.
  final int initialStoryPosition;

  /// Story view opening content position.
  final int initialContentPosition;

  /// Whether the tray will animate when story view is opened. This is set by
  /// [AdvStory] and first content uses it to determine whether it should show
  /// loading screen or not.
  final bool trayWillAnimate;

  int _content;
  int _story;

  /// Status of the content in the postion.
  StoryStatus status = StoryStatus.stop;

  /// Updates any [PositionNotifier] variable and calls listeners.
  void update({int? content, int? story, StoryStatus? status}) {
    bool isChanged = false;

    if (content != null && content != _content) {
      _content = content;
      status = StoryStatus.play;
      isChanged = true;
    }

    if (story != null && story != _story) {
      _story = story;
      status = StoryStatus.play;
      isChanged = true;
    }

    if (status != null && status != this.status) {
      this.status = status;
      isChanged = true;
    }

    if (isChanged) notifyListeners();
  }

  @override
  void addListener(void Function() listener, {StoryPosition? position}) {
    if (position == this) {
      listener();
    }
    super.addListener(listener);
  }

  @override
  int get content => _content;

  @override
  int get story => _story;

  @override
  bool operator ==(Object other) =>
      other is StoryPosition &&
      content == other.content &&
      story == other.story;

  @override
  int get hashCode => Object.hash(content, story);

  @override
  String toString() => 'StoryPosition(content: $content, story: $story)';
}

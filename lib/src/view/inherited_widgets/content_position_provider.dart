import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// Provides it's position to a story contents.
class ContentPositionProvider extends InheritedWidget {
  /// Creates position provider instance. Story contents can know it's position
  /// using this widget.
  const ContentPositionProvider({
    required Widget child,
    required this.position,
    Key? key,
  }) : super(key: key, child: child);

  /// The position of the story as (storyIndex, contentIndex)
  final StoryPosition position;

  /// Returns the [ContentPositionProvider] from the [BuildContext].
  static ContentPositionProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ContentPositionProvider>();
  }

  @override
  bool updateShouldNotify(ContentPositionProvider oldWidget) => false;
}

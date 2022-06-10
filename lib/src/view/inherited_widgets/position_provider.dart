import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// Provides it's position to a story contents.
class PositionProvider extends InheritedWidget {
  /// Creates position provider instance. Story contents can know it's position
  /// using this widget.
  const PositionProvider({
    required Widget child,
    required this.position,
    Key? key,
  }) : super(key: key, child: child);

  /// The position of the story as (storyIndex, contentIndex)
  final StoryPosition position;

  /// Returns the [PositionProvider] from the [BuildContext].
  static PositionProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PositionProvider>();
  }

  @override
  bool updateShouldNotify(PositionProvider oldWidget) => false;
}

import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// View for custom stories.
class WidgetItem extends StatelessWidget {
  /// Creates a widget story view.
  const WidgetItem({
    required this.child,
    required this.position,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final StoryPosition position;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}

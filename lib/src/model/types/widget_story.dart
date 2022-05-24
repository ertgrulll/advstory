import 'package:advstory/src/model/types/story.dart';
import 'package:flutter/material.dart';

/// Data model for widget stories.
class WidgetStory extends Story {
  /// Holds the data to be used to create the custom story.
  const WidgetStory({
    required this.child,
    Widget? header,
    Widget? footer,
  }) : super(header: header, footer: footer);

  /// The widget to display.
  final Widget child;
}

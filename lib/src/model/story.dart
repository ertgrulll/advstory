import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:advstory/src/view/default_components/story_header.dart';
import 'package:flutter/material.dart';

/// Group of image, media or custom story contents. A story may include one
/// or more contents.
///
/// This class keeps the default header and footer of a story and a generator
/// function to creating it's contents. [contentBuilder] function called when
/// story contents skipped by tapping left/right sides of the screen.
///
/// > [contentBuilder] function can be called multiple times while skipping
/// > story content. Make sure this function is pure, return only story content
/// > from this function and don't take any extra action.
///
/// [contentCount] - 1 is the largest number passed as parameter to the
/// [contentBuilder] function.
class Story {
  /// Creates a new story.
  Story({
    required this.contentCount,
    required this.contentBuilder,
    this.header,
    this.footer,
  });

  /// Function that will be called to build a [AdvStoryContent].
  ///
  /// May be called multiple times. Do not make heavy calculations in this
  /// method to avoid performance issues.
  final ContentBuilder contentBuilder;

  /// Nnumber of the content in this story.
  final int contentCount;

  /// Top section of story.
  /// Most probably story owner's profile picture and name.
  ///
  /// If null, the story's top section will be empty.
  /// You can use default [StoryHeader].
  final Widget? header;

  /// Bottom section of story.
  ///
  /// If null, the story's bottom section will be empty.
  final Widget? footer;
}

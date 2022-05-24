import 'package:advstory/advstory.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/view/components/items/image_item.dart';
import 'package:advstory/src/view/components/items/video_item.dart';
import 'package:advstory/src/view/components/items/widget_item.dart';
import 'package:flutter/material.dart';

extension TypeConverter on Story {
  /// Converts [Story] to it's view.
  Widget asView(StoryPosition position) {
    if (this is ImageStory) {
      return ImageItem(
        story: this as ImageStory,
        position: position,
      );
    } else if (this is VideoStory) {
      return VideoItem(
        story: this as VideoStory,
        position: position,
      );
    } else {
      return WidgetItem(position: position, child: (this as WidgetStory).child);
    }
  }
}

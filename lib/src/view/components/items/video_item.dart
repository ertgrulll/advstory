import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/items/story_item.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// View for video story.
class VideoItem extends StoryItem {
  /// Creates a video story view.
  const VideoItem({
    required VideoStory story,
    required StoryPosition position,
    Key? key,
  }) : super(
          key: key,
          story: story,
          position: position,
        );

  @override
  VideoItemState createState() => VideoItemState();
}

class VideoItemState extends StoryItemState<VideoItem, VideoPlayerController> {
  @override
  Widget build(BuildContext context) {
    if (resource?.value.isInitialized == true) {
      return Center(
        child: AspectRatio(
          aspectRatio: resource!.value.aspectRatio,
          child: VideoPlayer(resource!),
        ),
      );
    }

    return loadingScreen;
  }
}

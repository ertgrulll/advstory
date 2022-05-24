import 'package:advstory/src/view/components/items/image_item.dart';
import 'package:advstory/src/view/components/items/video_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stores [ImageProvider] for [ImageItem], [VideoPlayerController] for
/// [VideoItem].
///
/// Also provides a way to listen to the loading status.
abstract class StoryResource {
  StoryResource({
    bool isLoaded = false,
  }) : isLoaded = ValueNotifier(isLoaded);

  final ValueNotifier<bool> isLoaded;
}

/// Resource store for [ImageItem]'s.
class ImageResource extends StoryResource {
  ImageResource({
    bool isLoaded = false,
    this.image,
  }) : super(isLoaded: isLoaded);

  ImageProvider<FileImage>? image;
}

/// Resource store for [VideoItem]'s.
class VideoResource extends StoryResource {
  VideoResource({
    bool isLoaded = false,
    this.videoController,
  }) : super(isLoaded: isLoaded);

  VideoPlayerController? videoController;
}

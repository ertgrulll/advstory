import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/items/story_item.dart';
import 'package:flutter/material.dart';

/// View for image stories
class ImageItem extends StoryItem {
  /// Creates full screen image story
  const ImageItem({
    required ImageStory story,
    required StoryPosition position,
    Key? key,
  }) : super(
          key: key,
          position: position,
          story: story,
        );

  @override
  ImageItemState createState() => ImageItemState();
}

class ImageItemState extends StoryItemState<ImageItem, ImageProvider> {
  @override
  Widget build(BuildContext context) {
    if (resource == null) return loadingScreen;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Image(
        image: resource!,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame != null) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.ease,
              duration: const Duration(milliseconds: 200),
              builder: (BuildContext context, double opacity, _) {
                return Opacity(opacity: opacity, child: child);
              },
            );
          }

          return loadingScreen;
        },
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    );
  }
}

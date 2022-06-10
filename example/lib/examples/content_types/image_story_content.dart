import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// Example of image content.
class ImageStoryContent extends StatelessWidget {
  /// Creates [AdvStory] view for image content example.
  const ImageStoryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvStory(
      storyCount: 5,
      storyBuilder: (storyIndex) {
        return Story(
          contentCount: 5,
          contentBuilder: (contentIndex) {
            return ImageContent(
              // Story image url
              url: imageUrls[contentIndex % imageUrls.length],
              // Story duration, default is 10 seconds
              duration: const Duration(seconds: 10),
              // Story content cache key, default is null
              cacheKey: imageUrls[contentIndex % imageUrls.length],
              // Story content request headers, default is null
              requestHeaders: const {
                "Authorization": "Bearer 12345",
              },
              // Story content header, default is null
              header: const Text(
                "Header",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              // Story content footer, default is null
              footer: const Text(
                "Footer",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
              // Story content timeout, default is null
              timeout: const Duration(seconds: 5),
              // Error view builder.
              errorBuilder: () {
                /// You can create a timer here to skip next content using
                /// AdvStoryController.
                return const Center(
                  child: Text("An error occured!"),
                );
              },
            );
          },
        );
      },
      trayBuilder: (storyIndex) {
        return Center(
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent.withOpacity(.85),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Image Content\n$storyIndex",
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

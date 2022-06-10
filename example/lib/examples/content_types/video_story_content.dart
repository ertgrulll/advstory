import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// Example of video content.
class VideoStoryContent extends StatelessWidget {
  /// Creates [AdvStory] view for video content example.
  const VideoStoryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvStory(
      storyCount: 5,
      // This example creates only video contents, video sizes are large.
      // Disable story preload.
      preloadStory: false,
      storyBuilder: (storyIndex) {
        return Story(
          contentCount: 2,
          contentBuilder: (contentIndex) {
            return VideoContent(
              // Story video url
              url: videoUrls[contentIndex % videoUrls.length],
              // Story content cache key, default is null
              cacheKey: videoUrls[contentIndex % videoUrls.length],
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
              timeout: const Duration(seconds: 10),
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
              color: Colors.lightBlueAccent.withOpacity(.85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Video Content\n$storyIndex",
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

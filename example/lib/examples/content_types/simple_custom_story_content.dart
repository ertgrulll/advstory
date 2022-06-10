import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// Example of simple custom content.
class SimpleCustomStoryContent extends StatelessWidget {
  /// Creates [AdvStory] view for simple custom content example.
  const SimpleCustomStoryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvStory(
      storyCount: 5,
      storyBuilder: (storyIndex) {
        return Story(
          contentCount: 4,
          header: const Text(
            "Header",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          footer: const Text(
            "Footer",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          contentBuilder: (contentIndex) {
            return SimpleCustomContent(
              // Use story header for every 3rd content.
              useStoryHeader: contentIndex % 3 == 0,
              // Use story footer for every 2nd content.
              useStoryFooter: contentIndex % 2 == 0,
              // Start 10 second countdown for content skipping.
              duration: const Duration(seconds: 10),
              builder: (context) {
                return Center(
                  child: SizedBox.expand(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent.withOpacity(.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text("My story content for $contentIndex"),
                    ),
                  ),
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
              color: Colors.greenAccent.withOpacity(.85),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              "Simple Content\n$storyIndex",
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

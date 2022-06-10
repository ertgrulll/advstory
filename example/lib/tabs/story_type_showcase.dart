import 'package:example/examples/content_types/advanced_custom_story_content.dart';
import 'package:example/examples/content_types/image_story_content.dart';
import 'package:example/examples/content_types/simple_custom_story_content.dart';
import 'package:example/examples/content_types/video_story_content.dart';
import 'package:flutter/material.dart';

/// This is not a usage example.
///
/// Look at lib/examples folder to see how to use this package.
class StoryTypeShowcase extends StatelessWidget {
  const StoryTypeShowcase({Key? key}) : super(key: key);

  Widget _text(String value) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 8, top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.black38,
            width: 4,
          ),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                children: [
                  _text("lib/examples/content_types/image_story_content.dart"),
                  const Expanded(child: ImageStoryContent()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _text("lib/examples/content_types/video_story_content.dart"),
                  const Expanded(child: VideoStoryContent()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _text(
                    "lib/examples/content_types/simple_custom_story_content.dart",
                  ),
                  const Expanded(child: SimpleCustomStoryContent()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _text(
                    "lib/examples/content_types/advanced_custom_story_content.dart",
                  ),
                  const Expanded(child: AdvancedCustomStoryContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

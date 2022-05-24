import 'package:advstory/advstory.dart';
import 'package:example/data_generator.dart';
import 'package:flutter/material.dart';

/// This is not a usage example, just created to change trays for showcase.
/// Look at examples folder to see how to use this package.
class StoryView extends StatelessWidget {
  const StoryView({
    required this.data,
    required this.isHorizontal,
    required this.title,
    required this.trayBuilder,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final List<User> data;
  final bool isHorizontal;
  final String title;
  final Widget Function(int) trayBuilder;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isHorizontal ? 80 : double.maxFinite,
      width: isHorizontal ? double.maxFinite : 80,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Expanded(
            child: AdvStory(
              clusterCount: data.length,
              clusterBuilder: (index) async {
                return Cluster(
                  storyCount: data[index].stories.length,
                  storyBuilder: (storyIndex) {
                    final story = data[index].stories[storyIndex];

                    switch (story.mediaType) {
                      case MediaType.video:
                        return VideoStory(url: story.url);

                      case MediaType.image:
                        return ImageStory(url: story.url);

                      case MediaType.widget:
                        return WidgetStory(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            alignment: Alignment.center,
                            color: Colors.orange,
                            child: const Text(
                              "AdvStory supports custom widgets as stories.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                    }
                  },
                );
              },
              trayBuilder: trayBuilder,
              style: AdvStoryStyle(
                trayStyle: TrayStyle(
                  direction: isHorizontal ? Axis.horizontal : Axis.vertical,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:advstory/advstory.dart';
import 'package:example/data_generator.dart';
import 'package:flutter/material.dart';

/// This class is an example of using custom header and footer specific
/// to a story.
class CustomHeaderFooter extends StatelessWidget {
  const CustomHeaderFooter({required this.data, Key? key}) : super(key: key);

  final List<User> data;

  /// Provides custom header and footer to every 2 story. Others still use
  /// the default header and footer.
  Widget? _getStoryComponent(int index, String type, BuildContext context) {
    return index % 2 == 0
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent.withOpacity(.85),
              borderRadius: BorderRadius.vertical(
                top: type == "footer" ? const Radius.circular(20) : Radius.zero,
                bottom:
                    type == "header" ? const Radius.circular(20) : Radius.zero,
              ),
            ),
            child: Text("Custom $type for story $index"),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return AdvStory(
      clusterCount: data.length,
      clusterBuilder: (clusterIndex) {
        return Cluster(
          storyCount: data[clusterIndex].stories.length,
          // Creates default header for cluster.
          header: ClusterHeader(
            url: data[clusterIndex].profilePicture,
            text: data[clusterIndex].username,
          ),
          // Creates default footer for cluster.
          footer: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            color: Colors.green.withOpacity(.5),
            alignment: Alignment.center,
            child: const Text("Default cluster footer"),
          ),
          storyBuilder: (storyIndex) {
            final story = data[clusterIndex].stories[storyIndex];

            final header = _getStoryComponent(
              storyIndex,
              "header",
              context,
            );

            final footer = _getStoryComponent(
              storyIndex,
              "footer",
              context,
            );

            switch (story.mediaType) {
              case MediaType.video:
                return VideoStory(
                  url: story.url,
                  header: header,
                  footer: footer,
                );

              case MediaType.image:
                return ImageStory(
                  url: story.url,
                  header: header,
                  footer: footer,
                );
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
      trayBuilder: (index) {
        return AdvStoryTray(
          url: data[index].profilePicture,
          username: Text(
            data[index].username,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          size: const Size(80, 80),
        );
      },
    );
  }
}

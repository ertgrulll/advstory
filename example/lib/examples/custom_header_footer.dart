import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// This class is an example of using custom header and footer specific
/// to a story. Creates story specific header&footer for every second story.
///
/// When you provide header/footer parameters for `ImageContent` or
/// `VideoContent`, AdvStory ignores default story header/footer and builds
/// content-specific components.
///
/// [SimpleCustomContent] accepts 'useStoryHeader' and 'useStoryFooter'
/// parameters, you can apply default story header and footer to
/// [SimpleCustomContent] or you can create your header/footer in your view.
class CustomHeaderFooter extends StatelessWidget {
  const CustomHeaderFooter({Key? key}) : super(key: key);

  /// Provides custom header and footer to every 2 story. Others use the
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
      storyCount: userNames.length,
      storyBuilder: (storyIndex) {
        return Story(
          contentCount: 3,
          // Creates default header for story.
          header: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            color: Colors.green.withOpacity(.5),
            alignment: Alignment.center,
            child: const Text("Default story header"),
          ),
          // Creates default footer for story.
          footer: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            color: Colors.green.withOpacity(.5),
            alignment: Alignment.center,
            child: const Text("Default story footer"),
          ),
          contentBuilder: (contentIndex) {
            final header = _getStoryComponent(contentIndex, "header", context);
            final footer = _getStoryComponent(contentIndex, "footer", context);

            return ImageContent(
              url: imageUrls[contentIndex],
              header: header,
              footer: footer,
            );
          },
        );
      },
      trayBuilder: (index) {
        return AdvStoryTray(
          url: profilePics[index],
          username: Text(
            userNames[index],
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

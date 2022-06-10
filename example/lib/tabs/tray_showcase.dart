import 'package:advstory/advstory.dart';
import 'package:example/examples/trays/adv_story_tray_customization.dart';
import 'package:example/examples/trays/custom_animated_tray.dart';
import 'package:example/examples/trays/custom_non_animated_tray.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// This is not a usage example.
///
/// Look at lib/examples folder to see how to use this package.
class TrayShowcase extends StatefulWidget {
  const TrayShowcase({Key? key}) : super(key: key);

  @override
  State<TrayShowcase> createState() => _TrayShowcaseState();
}

class _TrayShowcaseState extends State<TrayShowcase> {
  bool _isHorizontal = true;

  Widget _title(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('AdvStory Demo'),
        backgroundColor: Colors.deepOrangeAccent.withOpacity(.8),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Flex(
          direction: _isHorizontal ? Axis.vertical : Axis.horizontal,
          children: [
            AdvStoryTrayCustomization(isHorizontal: _isHorizontal),
            const Spacer(),
            if (_isHorizontal) _title("Animated Custom Tray"),
            SizedBox(
              height: _isHorizontal ? 100 : double.maxFinite,
              width: _isHorizontal ? double.maxFinite : 100,
              child: AdvStory(
                // Disable story build on scroll to increasing animation
                // duration.
                buildStoryOnTrayScroll: false,
                style: AdvStoryStyle(
                  trayListStyle: TrayListStyle(
                    direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
                  ),
                ),
                storyCount: userNames.length,
                storyBuilder: (index) {
                  return Story(
                    contentCount: 3,
                    contentBuilder: (contentIndex) {
                      return contentIndex % 2 == 0
                          ? VideoContent(url: videoUrls[contentIndex])
                          : ImageContent(url: imageUrls[contentIndex]);
                    },
                  );
                },
                trayBuilder: (index) => CustomAnimatedTray(
                  profilePic: profilePics[index],
                ),
              ),
            ),
            const Spacer(),
            if (_isHorizontal) _title("Non Animated Custom Tray"),
            SizedBox(
              height: _isHorizontal ? 80 : double.maxFinite,
              width: _isHorizontal ? double.maxFinite : 80,
              child: AdvStory(
                style: AdvStoryStyle(
                  trayListStyle: TrayListStyle(
                    direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
                  ),
                ),
                storyCount: userNames.length,
                storyBuilder: (index) {
                  return Story(
                    contentCount: 3,
                    contentBuilder: (contentIndex) {
                      return contentIndex % 2 == 0
                          ? VideoContent(url: videoUrls[contentIndex])
                          : ImageContent(url: imageUrls[contentIndex]);
                    },
                  );
                },
                trayBuilder: (index) => Center(
                  child: CustomNonAnimatedTray(
                    profilePic: profilePics[index],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent.withOpacity(.8),
        onPressed: () {
          setState(() {
            _isHorizontal = !_isHorizontal;
          });
        },
        child: const Icon(Icons.rotate_90_degrees_cw_outlined),
      ),
    );
  }
}

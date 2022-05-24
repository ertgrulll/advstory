import 'package:example/data_generator.dart';
import 'package:example/examples/any_widget_tray.dart';
import 'package:example/examples/custom_animated_tray.dart';
import 'package:example/examples/custom_non_animated_tray.dart';
import 'package:example/examples/adv_story_tray_customization.dart';
import 'package:example/story_view.dart';
import 'package:flutter/material.dart';

class TrayShowcase extends StatefulWidget {
  const TrayShowcase({required this.data, Key? key}) : super(key: key);

  final List<User> data;

  @override
  State<TrayShowcase> createState() => _TrayShowcaseState();
}

class _TrayShowcaseState extends State<TrayShowcase> {
  bool _isHorizontal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Flex(
          direction: _isHorizontal ? Axis.vertical : Axis.horizontal,
          children: [
            AdvStoryTrayCustomization(
              data: widget.data,
              isHorizontal: _isHorizontal,
            ),
            Expanded(
              child: StoryView(
                title: "Animated Custom Tray",
                data: widget.data,
                isHorizontal: _isHorizontal,
                trayBuilder: (index) {
                  return CustomAnimatedTray(
                    profilePic: widget.data[index].profilePicture,
                  );
                },
              ),
            ),
            Expanded(
              child: StoryView(
                data: widget.data,
                isHorizontal: _isHorizontal,
                title: "Non Animated Custom Tray",
                trayBuilder: (index) => CustomNonAnimatedTray(
                  profilePic: widget.data[index].profilePicture,
                ),
              ),
            ),
            Expanded(
              child: StoryView(
                data: widget.data,
                isHorizontal: _isHorizontal,
                title: "Trays can be any widget",
                trayBuilder: (index) {
                  final texts = ["Trays", "can", "be", "any", "widget"];
                  final colors = [
                    Colors.deepOrange,
                    Colors.lightBlue,
                    Colors.redAccent,
                    Colors.deepPurple,
                    Colors.teal,
                  ];

                  return AnyWidgetTray(
                    content: texts[index % 5],
                    color: colors[index % 5],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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

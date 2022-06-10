import 'dart:math';
import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// This widget demonstrates all possible customization options for
/// [AdvStoryTray].
class AdvStoryTrayCustomization extends StatefulWidget {
  const AdvStoryTrayCustomization({
    required this.isHorizontal,
    Key? key,
  }) : super(key: key);

  /// Story list direction
  final bool isHorizontal;

  @override
  State<AdvStoryTrayCustomization> createState() =>
      _AdvStoryTrayCustomizationState();
}

class _AdvStoryTrayCustomizationState extends State<AdvStoryTrayCustomization> {
  double _width = 85;
  double _height = 85;
  double _radius = 50;
  double _strokeWidth = 2;
  double _gapSize = 3;
  bool _showUserNames = false;

  final _defaultBorderColors = [
    const Color(0xaf405de6),
    const Color(0xaf5851db),
    const Color(0xaf833ab4),
    const Color(0xafc13584),
    const Color(0xafe1306c),
    const Color(0xaffd1d1d),
    const Color(0xaf405de6),
  ];
  late List<Color> _selectedColors = _defaultBorderColors;

  double _lerp = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isHorizontal ? _height + 60 : double.maxFinite,
      width: widget.isHorizontal ? double.maxFinite : _width + 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "AdvStoryTray Customization",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      barrierColor: Colors.black.withOpacity(.1),
                      builder: (context) {
                        return _controls();
                      },
                    );
                  },
                  child: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Expanded(
            child: AdvStory(
              storyCount: userNames.length,
              storyBuilder: (index) async {
                return Story(
                  contentCount: 3,
                  contentBuilder: (contentIndex) => contentIndex % 2 == 0
                      ? ImageContent(url: imageUrls[contentIndex])
                      : VideoContent(url: videoUrls[contentIndex]),
                  header: StoryHeader(
                    url: profilePics[index],
                    text: userNames[index],
                  ),
                  footer: const MessageBox(),
                );
              },
              style: AdvStoryStyle(
                trayListStyle: TrayListStyle(
                  direction:
                      widget.isHorizontal ? Axis.horizontal : Axis.vertical,
                ),
              ),
              trayBuilder: (index) {
                return AdvStoryTray(
                  url: profilePics[index],
                  size: Size(_width, _height),
                  shape: BoxShape.rectangle,
                  borderRadius: index % 2 == 0 ? _radius : _radius / 2,
                  borderGradientColors: _selectedColors,
                  strokeWidth: _strokeWidth,
                  gapSize: _gapSize,
                  username: _showUserNames
                      ? Text(
                          userNames[index],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls() {
    return StatefulBuilder(builder: (context, setModalState) {
      void set(VoidCallback callback) {
        setModalState(callback);
        setState(callback);
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Show user names"),
                  const SizedBox(width: 5),
                  Checkbox(
                    checkColor: Colors.white,
                    value: _showUserNames,
                    onChanged: (bool? value) {
                      set(() {
                        _showUserNames = !_showUserNames;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          _buildSlider(
            title: "Width: ",
            value: _width,
            min: 35,
            onChanged: (double value) {
              set(() {
                _width = value;
              });
            },
          ),
          _buildSlider(
            title: "Height: ",
            value: _height,
            min: 35,
            onChanged: (double value) {
              set(() {
                _height = value;
              });
            },
          ),
          _buildSlider(
            title: "Radius: ",
            value: _radius,
            min: 0,
            onChanged: (double value) {
              set(() {
                _radius = value;
              });
            },
          ),
          _buildSlider(
            title: "Gap size: ",
            value: _gapSize * 10,
            min: 0,
            onChanged: (double value) {
              set(() {
                _gapSize = value / 10;
              });
            },
          ),
          _buildSlider(
            title: "Stroke width: ",
            value: _strokeWidth * 10,
            min: 0,
            onChanged: (double value) {
              set(() {
                _strokeWidth = value / 10;
              });
            },
          ),
          _buildSlider(
            title: "Border gradient: ",
            value: _lerp,
            min: 0,
            onChanged: (double value) {
              final newColors = <Color>[];

              for (int i = 0; i < _defaultBorderColors.length; i++) {
                var rnd = Random();
                var r = rnd.nextInt(16) * 16;
                var g = rnd.nextInt(16) * 16;
                var b = rnd.nextInt(16) * 16;

                newColors.add(Color.fromARGB(255, r, g, b));
              }

              set(() {
                _selectedColors = newColors;
                _lerp = value;
              });
            },
          ),
        ],
      );
    });
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Text(title),
          const SizedBox(width: 5),
          Expanded(
            child: Slider(
              value: value,
              max: 200,
              min: min,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Creates a dumb textfield as a placeholder.
class MessageBox extends StatelessWidget {
  const MessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      margin: const EdgeInsets.only(bottom: 25),
      color: Colors.transparent,
      child: TextField(
        cursorRadius: const Radius.circular(20.0),
        decoration: InputDecoration(
          fillColor: Colors.white10,
          filled: true,
          suffixIcon: Icon(
            Icons.send_outlined,
            size: 20,
            color: Colors.grey.shade300,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'Message',
          hintStyle: const TextStyle(
            fontSize: 15,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}

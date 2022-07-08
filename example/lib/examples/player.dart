import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// Example for [AdvStory.player] usage.
///
/// [AdvStory.player] constructor allows to create a story view without
/// tray list. Also you can set story view's size, position or anything you
/// want like any other widget.
///
/// This example opens and closes story view with button taps.
class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final _controller = AdvStoryPlayerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: const [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'AdvStory.player builds a story view without a tray list.'
                        ' Custom open animation, size, position and anything'
                        ' desired can be applied to the story view. \n',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Player Example'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: const Text('Open'),
                          onPressed: () =>
                              _controller.open(StoryPosition(2, 2)),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          child: const Text('Close'),
                          onPressed: () => _controller.close(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .5,
                  child: AdvStory.player(
                    storyCount: profilePics.length,
                    controller: _controller,
                    style: const AdvStoryStyle(
                      indicatorStyle: IndicatorStyle(
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                    storyBuilder: (storyIndex) => Story(
                      contentCount: 3,
                      contentBuilder: (contentIndex) {
                        return SimpleCustomContent(
                          builder: (context) {
                            return Container(
                              color: Colors.blueAccent,
                              alignment: Alignment.center,
                              child: const Text('😎'),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

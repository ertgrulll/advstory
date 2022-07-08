import 'dart:developer';

import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// Example for interceptor usage.
///
/// Interceptor, allows to blocking and replacing default event actions.
/// Story flow can be manipulated seamlessly using interceptors without
/// application user noticing.
class Interceptor extends StatefulWidget {
  const Interceptor({Key? key}) : super(key: key);

  @override
  State<Interceptor> createState() => _InterceptorState();
}

class _InterceptorState extends State<Interceptor> {
  final _controller = AdvStoryController();

  @override
  void initState() {
    _controller.setTrayTapInterceptor((trayIndex) {
      if (trayIndex == 0) {
        return StoryPosition(2, 2);
      }

      return null;
    });

    _controller.setInterceptor((event) {
      if (event == StoryEvent.nextContent) {
        return () => log(
              'StoryEvent.nextContent blocked and printed this log instead.',
            );
      }

      return null;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Interceptor Example',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'This example,\n'
                '- Blocks next content event and prints a log message '
                'instead.\n'
                '- Opens story view at story 2 and content 2 when tray 0 '
                'tapped.',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: AdvStory(
            controller: _controller,
            storyCount: profilePics.length,
            storyBuilder: (index) => Story(
              contentCount: 3,
              contentBuilder: (contentIndex) => SimpleCustomContent(
                builder: (context) {
                  return Center(
                    child: SizedBox.expand(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent.withOpacity(.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text("Story $index, Content: $contentIndex"),
                      ),
                    ),
                  );
                },
              ),
            ),
            trayBuilder: (index) => AdvStoryTray(url: profilePics[index]),
          ),
        ),
      ],
    );
  }
}

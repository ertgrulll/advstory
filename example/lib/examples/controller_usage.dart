import 'package:advstory/advstory.dart';
import 'package:example/examples/interceptor.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

class ControllerUsage extends StatefulWidget {
  const ControllerUsage({Key? key}) : super(key: key);

  @override
  State<ControllerUsage> createState() => _ControllerUsageState();
}

class _ControllerUsageState extends State<ControllerUsage> {
  final AdvStoryController _controller = AdvStoryController();

  // This is created to display snackbars about events. No need to
  // use any key for AdvStory.
  final _key = GlobalKey();

  /// Shows snackbars about events.
  void _showSnackbar(StoryEvent event, StoryPosition position) {
    void _show(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.none,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 50,
              right: 20,
              left: 20,
            ),
            content: Text(
              "Event: ${event.name}, story: ${position.story}, "
              "content: ${position.content}",
            ),
          ),
        );
      });
    }

    if (event == StoryEvent.close) {
      _show(context);
    } else if (_key.currentState?.context != null &&
        _key.currentState?.mounted == true) {
      _show(_key.currentState!.context);
    }
  }

  Widget _buildActionFooter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 50),
      color: Colors.grey[200],
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: [
          IconButton(
            onPressed: _controller.toPreviousStory,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _controller.toPreviousContent,
            icon: const Icon(Icons.skip_previous),
          ),
          IconButton(
            onPressed: _controller.pause,
            icon: const Icon(Icons.pause),
          ),
          IconButton(
            onPressed: _controller.resume,
            icon: const Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: _controller.toNextContent,
            icon: const Icon(Icons.skip_next),
          ),
          IconButton(
            onPressed: _controller.toNextStory,
            icon: const Icon(Icons.redo),
          ),
          IconButton(
            onPressed: _controller.disableGestures,
            icon: const Icon(Icons.do_not_touch_rounded),
          ),
          IconButton(
            onPressed: _controller.enableGestures,
            icon: const Icon(Icons.touch_app),
          ),
          IconButton(
            onPressed: _controller.hideComponents,
            icon: const Icon(Icons.visibility_off),
          ),
          IconButton(
            onPressed: _controller.showComponents,
            icon: const Icon(Icons.visibility),
          ),
          IconButton(
            onPressed: () => _controller.jumpTo(story: 0, content: 0),
            icon: const Icon(Icons.navigation),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptions() {
    Widget _desc(IconData icon, String desc) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            Text(desc),
          ],
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 6,
      children: [
        _desc(Icons.undo, "To previous story"),
        _desc(Icons.redo, "To next story"),
        _desc(Icons.skip_previous, "To previous content"),
        _desc(Icons.skip_next, "To next content"),
        _desc(Icons.pause, "Pause"),
        _desc(Icons.play_arrow, "Resume"),
        _desc(Icons.do_not_touch_rounded, "Disable gestures"),
        _desc(Icons.touch_app, "Enable gestures"),
        _desc(Icons.visibility_off, "Hide components"),
        _desc(Icons.visibility, "Show components"),
        _desc(Icons.navigation, "Jump to position"),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_showSnackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Controller Usage Example',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: AdvStory(
                  key: _key,
                  controller: _controller,
                  storyCount: userNames.length,
                  storyBuilder: (index) => Story(
                    footer: _buildActionFooter(),
                    contentCount: 3,
                    contentBuilder: (contentIndex) {
                      return SimpleCustomContent(
                        useStoryFooter: true,
                        builder: (context) {
                          return Container(
                            color: Colors.deepOrangeAccent,
                            child: Center(
                              child: Text(
                                "Content $contentIndex",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  trayBuilder: (index) => AdvStoryTray(
                    url: profilePics[index],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 15),
                child: Text(
                  "Icon Descriptions:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildDescriptions()),
              const Expanded(child: Interceptor()),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:example/data_generator.dart';
import 'package:flutter/material.dart';
import 'package:advstory/advstory.dart';

class ControllerUsage extends StatefulWidget {
  const ControllerUsage({required this.data, Key? key}) : super(key: key);

  final List<User> data;

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
              "Event: ${event.name}, cluster: ${position.cluster}, "
              "story: ${position.story}",
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
            onPressed: _controller.toPreviousCluster,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _controller.toPreviousStory,
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
            onPressed: _controller.toNextStory,
            icon: const Icon(Icons.skip_next),
          ),
          IconButton(
            onPressed: _controller.toNextCluster,
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
            onPressed: () => _controller.jumpTo(0, 0),
            icon: const Icon(Icons.navigation),
          ),
          IconButton(
            onPressed: () => _controller.setVolume(0),
            icon: const Icon(Icons.volume_up),
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
      childAspectRatio: 4,
      children: [
        _desc(Icons.undo, "To previous cluster"),
        _desc(Icons.redo, "To next cluster"),
        _desc(Icons.skip_previous, "To previous story"),
        _desc(Icons.skip_next, "To next story"),
        _desc(Icons.pause, "Pause"),
        _desc(Icons.play_arrow, "Resume"),
        _desc(Icons.do_not_touch_rounded, "Disable gestures"),
        _desc(Icons.touch_app, "Enable gestures"),
        _desc(Icons.visibility_off, "Hide components"),
        _desc(Icons.visibility, "Show components"),
        _desc(Icons.navigation, "Jump to position"),
        _desc(Icons.volume_up, "Set volume"),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This page shows how to use controller.",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 90,
              child: AdvStory(
                key: _key,
                controller: _controller,
                clusterCount: widget.data.length,
                clusterBuilder: (index) => Cluster(
                  storyCount: widget.data[index].stories.length,
                  footer: _buildActionFooter(),
                  storyBuilder: (storyIndex) {
                    final story = widget.data[index].stories[storyIndex];

                    switch (story.mediaType) {
                      case MediaType.video:
                        return VideoStory(
                          url: story.url,
                        );

                      case MediaType.image:
                        return ImageStory(url: story.url);

                      case MediaType.widget:
                        return WidgetStory(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            color: Colors.orange,
                            child: const Text(
                              "This is a widget story",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                    }
                  },
                ),
                trayBuilder: (index) => AdvStoryTray(
                  url: widget.data[index].profilePicture,
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
          ],
        ),
      ),
    );
  }
}

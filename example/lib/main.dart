import 'package:example/examples/controller_usage.dart';
import 'package:example/examples/player.dart';
import 'package:example/tabs/footer_header_showcase.dart';
import 'package:example/tabs/story_type_showcase.dart';
import 'package:example/tabs/tray_showcase.dart';
import 'package:flutter/material.dart';

/// All examples are in the lib/examples. Other classes are related to
/// UI and fake data, no need to check them.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdvStoryDemoApp());
}

class AdvStoryDemoApp extends StatelessWidget {
  const AdvStoryDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvStoryDemo(),
    );
  }
}

class AdvStoryDemo extends StatefulWidget {
  const AdvStoryDemo({Key? key}) : super(key: key);

  @override
  State<AdvStoryDemo> createState() => _AdvStoryDemoState();
}

class _AdvStoryDemoState extends State<AdvStoryDemo> {
  int _selectedIndex = 0;
  late final items = const [
    TrayShowcase(),
    StoryTypeShowcase(),
    FooterHeaderShowcase(),
    ControllerUsage(),
    Player(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Trays",
            icon: Icon(Icons.palette_outlined),
          ),
          BottomNavigationBarItem(
            label: "Contents",
            icon: Icon(Icons.extension),
          ),
          BottomNavigationBarItem(
            label: "Footer &\nHeader",
            icon: Icon(Icons.unfold_more_outlined),
          ),
          BottomNavigationBarItem(
            label: "Controller",
            icon: Icon(Icons.signpost_outlined),
          ),
          BottomNavigationBarItem(
            label: "Player",
            icon: Icon(Icons.play_circle_rounded),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}

import 'package:example/examples/controller_usage.dart';
import 'package:example/footer_header_showcase.dart';
import 'package:example/tray_showcase.dart';
import 'package:example/data_generator.dart';
import 'package:flutter/material.dart';

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
  final data = generateMockData();
  late final items = [
    TrayShowcase(data: data),
    FooterHeaderShowcase(data: data),
    ControllerUsage(data: data),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: items[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: "Tray Options",
              icon: Icon(Icons.palette_outlined),
            ),
            BottomNavigationBarItem(
              label: "Footer & Header",
              icon: Icon(Icons.unfold_more_outlined),
            ),
            BottomNavigationBarItem(
              label: "Controller Usage",
              icon: Icon(Icons.signpost_outlined),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepOrange,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
        ));
  }
}

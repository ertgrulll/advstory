import 'package:flutter/material.dart';

/// Creates a simple square tray with a custom color and text.
class AnyWidgetTray extends StatelessWidget {
  const AnyWidgetTray({
    required this.content,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 85,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(.6),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}

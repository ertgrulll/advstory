import 'package:advstory/src/view/components/tray/animated_tray.dart';
import 'package:flutter/material.dart';

/// Provides it's position to `AnimatedTray`.
class TrayPositionProvider extends InheritedWidget {
  /// Creates `TrayPositionProvider` instance. [index] keeps [AnimatedTray]
  /// position.
  const TrayPositionProvider({
    required Widget child,
    required this.index,
    Key? key,
  }) : super(child: child, key: key);

  final int index;

  @override
  bool updateShouldNotify(oldWidget) => false;

  static TrayPositionProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrayPositionProvider>();
  }
}

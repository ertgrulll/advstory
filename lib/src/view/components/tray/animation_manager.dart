import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/tray/animation_notifier.dart';
import 'package:flutter/material.dart';

/// Wrapper to handle animation start and stops.
///
/// Wraps classes that extends [AnimatedTray] and provides animnation start and
/// stop functionality.
class AnimationManager extends InheritedWidget {
  const AnimationManager({
    required Widget child,
    required this.notifier,
    Key? key,
  }) : super(child: child, key: key);

  final AnimationNotifier notifier;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget != this;

  static AnimationManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AnimationManager>();
  }
}

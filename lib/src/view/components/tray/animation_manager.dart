import 'package:advstory/advstory.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wrapper to handle animation start and stops.
///
/// Wraps classes that extends [AnimatedTray] and provides animnation start and
/// stop functionality.
class AnimationManager extends InheritedWidget {
  /// Creates animation manager.
  AnimationManager({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  /// Keeps listeners for animation start and stop.
  final listeners = ObserverList<AnimationNotifierCallback>();

  /// Registers a listener that will be called when the animation should start
  /// and end.
  ///
  /// This callback invokes when user taps on tray and when required media
  /// loaded and ready to show.
  void addListener(AnimationNotifierCallback listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /// Removes a registered listener.
  void removeListener(AnimationNotifierCallback listener) {
    if (listeners.contains(listener)) {
      listeners.remove(listener);
    }
  }

  /// Notifies listeners about animation start/stop.
  void update({required bool shouldAnimate}) {
    for (final listener in listeners) {
      listener(shouldAnimate);
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AnimationManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AnimationManager>();
  }
}

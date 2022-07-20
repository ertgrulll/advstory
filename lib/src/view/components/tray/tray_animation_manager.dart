import 'package:advstory/advstory.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:flutter/material.dart';

/// Wrapper to handle animation start and stops.
///
/// Wraps classes that extends [AnimatedTray] and provides animnation start and
/// stop functionality.
class TrayAnimationManager extends InheritedWidget {
  /// Creates animation manager.
  TrayAnimationManager({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  /// Keeps listeners for animation start and stop.
  final _listeners = <int, AnimationNotifierCallback>{};

  /// Registers a listener that will be called when the animation should start
  /// and end.
  ///
  /// This callback invokes when user taps on tray and when required media
  /// loaded and ready to show.
  void addListener(AnimationNotifierCallback listener, int index) {
    _listeners[index] = listener;
  }

  /// Removes a registered listener.
  void removeListener(int index) => _listeners.remove(index);

  /// Notifies listeners about animation start/stop.
  void update({required bool shouldAnimate, required int index}) {
    _listeners[index]?.call(shouldAnimate);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static TrayAnimationManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrayAnimationManager>();
  }
}

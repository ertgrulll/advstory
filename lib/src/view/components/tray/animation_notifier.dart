import 'package:advstory/src/contants/types.dart';
import 'package:flutter/foundation.dart';

/// Notifies listeners about when tray animation should start and stop.
class AnimationNotifier {
  AnimationNotifier();

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
  void notifyListeners({required bool shouldAnimate}) {
    for (final listener in listeners) {
      listener(shouldAnimate);
    }
  }
}

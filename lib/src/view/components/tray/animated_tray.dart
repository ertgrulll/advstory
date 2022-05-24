import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/tray/animation_manager.dart';
import 'package:advstory/src/view/components/tray/animation_notifier.dart';
import 'package:flutter/material.dart';

/// Base class for animated story trays, animated trays must extend this
/// class to let AdvStory know that it should handle animation start and stops
/// for this tray. Otherwise your custom tray animation may never start or stop.
///
/// To create an animated tray extend [AnimatedTray] class, define your own
/// animations, override startAnimation and stopAnimation methods and let to
/// [AdvStory] handle animation starts and stops.
///
/// When a tray should animate, [AdvStory] calls `startAnimation` method.
/// When a tray should stop animating, [AdvStory] calls `stopAnimation` method.
abstract class AnimatedTray extends StatefulWidget {
  const AnimatedTray({Key? key}) : super(key: key);

  @override
  AnimatedTrayState createState();
}

abstract class AnimatedTrayState<T extends AnimatedTray> extends State<T> {
  AnimationNotifier? _notifier;

  /// Start your animation inside of this method.
  ///
  /// When tray needs to start animation, [AdvStory] changes animationNotifier
  /// status to true and this causes call to this method.
  @protected
  void startAnimation();

  /// Stop your animation inside of this method.
  ///
  /// When tray needs to stop animation, [AdvStory] changes animationNotifier
  /// status to false and this causes call to this method.
  @protected
  void stopAnimation();

  void _animationListener(bool shouldAnimate) {
    shouldAnimate ? startAnimation() : stopAnimation();
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    _notifier = AnimationManager.of(context)?.notifier;

    if (_notifier?.listeners.isEmpty == true) {
      _notifier?.addListener(_animationListener);
    }

    super.didChangeDependencies();
  }

  @override
  @mustCallSuper
  void dispose() {
    _notifier?.removeListener(_animationListener);

    super.dispose();
  }
}

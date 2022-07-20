import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/tray/tray_animation_manager.dart';
import 'package:advstory/src/view/components/tray/tray_position_provider.dart';
import 'package:flutter/material.dart';

/// Base class for animated story trays, animated trays must extend this
/// class to let AdvStory know that it should handle animation start and stops
/// for this tray. Otherwise your custom tray animation may never
/// starts or stops.
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

/// State class for AnimatedTray. This class provides way to controlling custom
/// animations.
abstract class AnimatedTrayState<T extends AnimatedTray> extends State<T> {
  TrayAnimationManager? _manager;
  late final int _position;

  /// Start your animation inside of this method.
  ///
  /// When tray needs to start animation, [AdvStory] calls this method.
  @protected
  void startAnimation();

  /// Stop your animation inside of this method.
  ///
  /// When tray needs to stop animation, [AdvStory] calls this method.
  @protected
  void stopAnimation();

  void _animationListener(bool shouldAnimate) {
    shouldAnimate ? startAnimation() : stopAnimation();
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    if (_manager == null) {
      _position = TrayPositionProvider.of(context)!.index;
      _manager = TrayAnimationManager.of(context);
      _manager!.addListener(_animationListener, _position);
    }

    super.didChangeDependencies();
  }

  @override
  @mustCallSuper
  void dispose() {
    _manager?.removeListener(_position);

    super.dispose();
  }
}

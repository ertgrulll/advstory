import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// An example of creating custom animations for story trays.
///
/// There are 2 important points to note:
/// - Start your animation inside of startAnimation function.
/// - Stop your animation inside of stopAnimation function.
class CustomAnimatedTray extends AnimatedTray {
  const CustomAnimatedTray({
    required this.profilePic,
    Key? key,
  }) : super(key: key);

  final String profilePic;

  @override
  AnimatedTrayState<AnimatedTray> createState() => CustomAnimatedTrayState();
}

class CustomAnimatedTrayState extends AnimatedTrayState<CustomAnimatedTray>
    with TickerProviderStateMixin {
  // Create a controller for the tray animation and define properties.
  // Use curves tweens etc. if you want.
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1000),
    value: 1,
    lowerBound: .9,
    upperBound: 1.1,
  );

  // This function called every time the tray is tapped.
  @override
  void startAnimation() {
    _controller.repeat(reverse: true);
  }

  // This function called when cluster built and it's first media ready to
  // display.
  @override
  void stopAnimation() {
    _controller.reset();
    _controller.stop();
  }

  @override
  void dispose() {
    // Dispose controller as usual.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ScaleTransition(
          scale: _controller,
          child: child,
        );
      },
      child: SizedBox(
        width: 85,
        height: 85,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              widget.profilePic,
            ),
          ),
        ),
      ),
    );
  }
}

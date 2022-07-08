import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// An example of creating custom animations for story trays.
///
/// There are 2 important points to note:
/// - Start your animation inside of `startAnimation`.
/// - Stop your animation inside of `stopAnimation`.
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
  // Use curves, tweens etc. if you want.
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1000),
    value: 1,
    lowerBound: 1,
    upperBound: 1.1,
  );

  // This function called every time the tray is tapped.
  //
  // When you return a class that extends AnimatedTray from tray builder,
  // AdvStory knows that it should prepare story and its content before it is
  // shown. On animated tray tap, AdvStory calls this function and starts
  // preparing the story, builds story, fetchs media file from internet and
  // initializes VideoController if content is a video.
  //
  // Start your animation in this function.
  @override
  void startAnimation() {
    _controller.repeat(reverse: true);
  }

  // When story built and it's content ready to be shown, AdvStory calls this
  // function and opens story view.
  //
  // Stop your animation in this function.
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
    return Center(
      child: ScaleTransition(
        scale: _controller,
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
      ),
    );
  }
}

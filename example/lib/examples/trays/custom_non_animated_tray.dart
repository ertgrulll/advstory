import 'dart:math' as math;
import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// Star shape story tray. Story trays can be any widget you want.
///
/// If you are not creating [SimpleCustomContent] only stories, consider
/// using [AdvStoryTray] or creating your own animated tray.
class CustomNonAnimatedTray extends StatelessWidget {
  /// Creates a custom tray to use in story list.
  const CustomNonAnimatedTray({
    required this.profilePic,
    Key? key,
  }) : super(key: key);

  final String profilePic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85,
      height: 85,
      child: Center(
        child: ClipPath(
          clipper: TrayClipper(6),
          child: Image.network(
            profilePic,
          ),
        ),
      ),
    );
  }
}

/// Clips a star shape.
class TrayClipper extends CustomClipper<Path> {
  /// Creates a clipper instance
  TrayClipper(this.points);

  /// The number of points of the star
  final int points;

  // Degrees to radians conversion
  double _degreeToRadian(double deg) => deg * (math.pi / 180.0);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double max = 2 * math.pi;

    double width = size.width;
    double halfWidth = width / 2;

    double wingRadius = halfWidth;
    double radius = halfWidth / 2;

    double degreesPerStep = _degreeToRadian(360 / points);
    double halfDegreesPerStep = degreesPerStep / 2;

    path.moveTo(width, halfWidth);

    for (double step = 0; step < max; step += degreesPerStep) {
      path.lineTo(halfWidth + wingRadius * math.cos(step),
          halfWidth + wingRadius * math.sin(step));
      path.lineTo(halfWidth + radius * math.cos(step + halfDegreesPerStep),
          halfWidth + radius * math.sin(step + halfDegreesPerStep));
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    TrayClipper starClipper = oldClipper as TrayClipper;
    return points != starClipper.points;
  }
}

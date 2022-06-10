import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Creates an animated border that wraps the tray image.
class AnimatedBorderPainter extends CustomPainter {
  AnimatedBorderPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradientColors,
    required this.gapSize,
    required this.animation,
    this.colorStops,
  }) : super(repaint: animation);

  final double gapSize;
  final double radius;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Animation<double> animation;
  final List<double>? colorStops;

  final _painter = Paint();
  late final Rect _outerRect;
  Path? path;

  /// Creates path for tray border. This path is not changes when tray
  /// animating.
  Path _createPath(Size size) {
    // Create outer rectangle equals size
    _outerRect = Offset.zero & size;
    final outerRRect =
        RRect.fromRectAndRadius(_outerRect, Radius.circular(radius));

    // Create inner rectangle smaller by strokeWidth
    final Rect innerRect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height - strokeWidth * 2,
    );

    final innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(
        radius - strokeWidth,
      ),
    );

    // Create difference between outer and inner paths and draw it
    final Path path1 = Path()..addRRect(outerRRect);
    final Path path2 = Path()..addRRect(innerRRect);

    return Path.combine(PathOperation.difference, path1, path2);
  }

  /// Updates shader using current animation value.
  Paint _updateShader() {
    // Rotate gradient to create gradient effect.
    final gradient = SweepGradient(
      colors: gradientColors,
      stops: colorStops,
      transform: GradientRotation(animation.value * 2 * math.pi),
    );

    // Apply gradient shader
    _painter.shader = gradient.createShader(_outerRect);

    return _painter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    path ??= _createPath(size);
    _updateShader();

    canvas.drawPath(path!, _painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'dart:math' as math;

import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/shimmer.dart';
import 'package:flutter/material.dart';

/// Animated container that displays a circular image with Instagram like
/// gradinet border.
class AdvStoryTray extends AnimatedTray {
  /// Pre defined story tray for AdvStory.
  /// This widget will shown to user in a horizontal or vertical list.
  ///
  /// [borderRadius] is the radius of the border that wraps the tray image.
  AdvStoryTray({
    Key? key,
    required this.url,
    this.username,
    this.size = const Size(80, 80),
    this.shimmerStyle = const ShimmerStyle(),
    this.shape = BoxShape.circle,
    this.borderGradientColors = const [
      Color(0xaf405de6),
      Color(0xaf5851db),
      Color(0xaf833ab4),
      Color(0xafc13584),
      Color(0xafe1306c),
      Color(0xaffd1d1d),
      Color(0xaf405de6),
    ],
    this.gapSize = 3,
    this.strokeWidth = 2,
    this.animationDuration = const Duration(milliseconds: 1200),
    double? borderRadius,
  })  : assert(
          () {
            if (shape == BoxShape.circle) {
              return size.width == size.height;
            }

            return true;
          }(),
          'Size width and height must be equal for a circular tray',
        ),
        assert(
          borderGradientColors.length >= 2,
          'At least 2 colors are required for tray border gradient',
        ),
        borderRadius = shape == BoxShape.circle
            ? size.width
            : borderRadius ?? size.width / 10,
        super(key: key);

  /// Image url. Creates a circular image using this url.
  final String url;

  /// Username of the user who posted the story. Displays this username
  /// in the bottom of the story tray.
  final Widget? username;

  /// The size of the story tray.
  final Size size;

  /// Border gradient colors. Two same colors will create a solid border.
  final List<Color> borderGradientColors;

  /// The style of the shimmer that showing untill media load.
  final ShimmerStyle shimmerStyle;

  /// Shap of the tray.
  final BoxShape shape;

  /// The stroke of the border that wraps the tray image.
  final double strokeWidth;

  /// The radius of the border that wraps the tray image.
  final double borderRadius;

  /// Transparent area size between image and the border.
  final double gapSize;

  /// Rotate animation duration of the border.
  final Duration animationDuration;

  @override
  AdvStoryTrayState createState() => AdvStoryTrayState();
}

/// State of the [AdvStoryTray] widget.
class AdvStoryTrayState extends AnimatedTrayState<AdvStoryTray>
    with TickerProviderStateMixin {
  late final _rotationController = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  );
  late List<Color> _gradientColors = widget.borderGradientColors;
  List<Color> _fadedColors = [];

  List<Color> _calculateFadedColors(List<Color> baseColors) {
    final colors = <Color>[];
    for (int i = 0; i < baseColors.length; i++) {
      final opacity = i == 0 ? 1 / baseColors.length : 1 / i;

      colors.add(
        baseColors[i].withOpacity(opacity),
      );
    }

    return colors;
  }

  @override
  void startAnimation() {
    setState(() {
      _gradientColors = _fadedColors;
    });

    _rotationController.repeat();
  }

  @override
  void stopAnimation() {
    _rotationController.stop();

    setState(() {
      _gradientColors = widget.borderGradientColors;
    });
  }

  @override
  void initState() {
    _fadedColors = _calculateFadedColors(widget.borderGradientColors);

    super.initState();
  }

  @override
  void didUpdateWidget(AdvStoryTray oldWidget) {
    if (oldWidget.borderGradientColors != widget.borderGradientColors) {
      _gradientColors = widget.borderGradientColors;
      _fadedColors = _calculateFadedColors(widget.borderGradientColors);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: Stack(
            children: [
              CustomPaint(
                painter: _BorderPainter(
                  gradientColors: _gradientColors,
                  gapSize: widget.gapSize,
                  radius: widget.shape == BoxShape.circle
                      ? widget.size.width
                      : widget.borderRadius,
                  strokeWidth: widget.strokeWidth,
                  animation: CurvedAnimation(
                    parent: Tween(begin: 0.0, end: 1.0).animate(
                      _rotationController,
                    ),
                    curve: Curves.slowMiddle,
                  ),
                ),
                child: SizedBox(
                  width: widget.size.width,
                  height: widget.size.height,
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius - (widget.strokeWidth + widget.gapSize),
                  ),
                  child: Image.network(
                    widget.url,
                    width: widget.size.width -
                        (widget.gapSize + widget.strokeWidth) * 2,
                    height: widget.size.height -
                        (widget.gapSize + widget.strokeWidth) * 2,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, _) {
                      return frame != null
                          ? TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: .1, end: 1),
                              curve: Curves.ease,
                              duration: const Duration(milliseconds: 300),
                              builder:
                                  (BuildContext context, double opacity, _) {
                                return Opacity(
                                  opacity: opacity,
                                  child: child,
                                );
                              },
                            )
                          : Shimmer(style: widget.shimmerStyle);
                    },
                    errorBuilder: (_, __, ___) {
                      return Icon(
                        Icons.error,
                        color: widget.shimmerStyle.baseColor,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.username != null) ...[
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomCenter,
            child: widget.username,
          ),
        ],
      ],
    );
  }
}

/// Creates an animated border that wraps the tray image.
class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradientColors,
    required this.gapSize,
    required this.animation,
  }) : super(repaint: animation);

  final double gapSize;
  final double radius;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Animation<double> animation;

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

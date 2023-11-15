import 'package:advstory/advstory.dart';
import 'package:advstory/src/util/animated_border_painter.dart';
import 'package:advstory/src/view/components/shimmer.dart';
import 'package:flutter/material.dart';

/// A highly customizable animated story tray.
///
/// Circular or rectangular image with gradient border. Shows shimmer effect
/// when tray image is getting ready to show.
///
/// When tapped, this widget starts a border rotation animation and stops the
/// animation when [AdvStory] prepares the contents of the tray.
///
/// [AdvStoryTray] is a predefined component, any widget can be used as a
/// story tray but it's recommended to create an animated tray by extending
/// [AnimatedTray] class.
///
/// ---
/// AdvStory checks the tray widget type when the tray builder is called. If
/// tray is subtype of [AnimatedTray], [AdvStory] prepares the tray content
/// before displaying the story view and manages the starting and stopping of
/// the tray animation.
///
/// See [AnimatedTray] for more information.
class AdvStoryTray extends AnimatedTray {
  /// Creates a story tray to show in story tray list.
  ///
  /// [borderRadius] sets tray and image border shape.
  AdvStoryTray({
    Key? key,
    required this.url,
    this.username,
    this.size = const Size(80, 80),
    this.shimmerStyle = const ShimmerStyle(),
    this.shape = BoxShape.circle,
    this.heightFrontImageProfile = 29,
    this.widthFrontImageProfile = 29,
    this.urlFrontImageProfile = '',
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
          (() => shape == BoxShape.circle ? size.width == size.height : true)(),
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

  /// Image url that shown as tray.
  final String url;

  /// Name of the user who posted the story. This username is displayed
  /// below the story tray.
  final Widget? username;

  /// Size of the story tray. For a circular tray, width and height must be
  /// equal.
  final Size size;
  final double widthFrontImageProfile;
  final double heightFrontImageProfile;
  final String urlFrontImageProfile;

  /// Border gradient colors. Two same color creates a solid border.
  final List<Color> borderGradientColors;

  /// Style of the shimmer that showing while preparing the tray content.
  final ShimmerStyle shimmerStyle;

  /// Shap of the tray.
  final BoxShape shape;

  /// Width of the stroke that wraps the tray image.
  final double strokeWidth;

  /// Radius of the border that wraps the tray image.
  final double borderRadius;

  /// Transparent area size between image and the border.
  final double gapSize;

  /// Rotate animation duration of the border.
  final Duration animationDuration;

  @override
  AnimatedTrayState<AdvStoryTray> createState() => _AdvStoryTrayState();
}

/// State of the [AdvStoryTray] widget.
class _AdvStoryTrayState extends AnimatedTrayState<AdvStoryTray>
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
    _rotationController.reset();

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
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height + 14,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: widget.size.width,
                height: widget.size.height,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: AnimatedBorderPainter(
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
                          widget.borderRadius -
                              (widget.strokeWidth + widget.gapSize),
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
                                    builder: (BuildContext context,
                                        double opacity, _) {
                                      return Opacity(
                                        opacity: opacity,
                                        child: child,
                                      );
                                    },
                                  )
                                : Shimmer(style: widget.shimmerStyle);
                          },
                          errorBuilder: (_, __, ___) {
                            return const Icon(Icons.error);
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: widget.widthFrontImageProfile,
              height: widget.heightFrontImageProfile,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.urlFrontImageProfile.isEmpty
                          ? widget.urlFrontImageProfile
                          : widget.urlFrontImageProfile),
                      fit: BoxFit.cover),
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  color: Colors.blueGrey),
            ),
          )
        ],
      ),
    );
  }
}

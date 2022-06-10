import 'package:advstory/advstory.dart';
import 'package:advstory/src/util/animated_border_painter.dart';
import 'package:flutter/material.dart';

/// Circular loading indicator.
class LoadingIndicator extends StatefulWidget {
  /// Creates a circular loading indicator show when content or story resources
  /// are loading.
  const LoadingIndicator({
    required this.style,
    Key? key,
  }) : super(key: key);

  /// Style for the loading indicator.
  final LoadingStyle style;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Color? _bg = widget.style.backgroundColor;

  void _setColors() {
    if (_bg != null) return;

    final isLight = Theme.of(context).brightness == Brightness.light;
    _bg = isLight ? const Color(0xFFFDFBF9) : const Color(0xFF1B1B1B);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.style.fillDuration,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    _setColors();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: _bg,
      child: Center(
        child: CustomPaint(
          painter: AnimatedBorderPainter(
            gradientColors: widget.style.gradientColors,
            gapSize: 0,
            radius: widget.style.size,
            strokeWidth: widget.style.strokeWidth,
            animation: CurvedAnimation(
              parent: Tween(begin: 0.0, end: 1.0).animate(
                _controller,
              ),
              curve: Curves.slowMiddle,
            ),
            colorStops: widget.style.colorStops,
          ),
          child: SizedBox(
            width: widget.style.size - widget.style.strokeWidth,
            height: widget.style.size - widget.style.strokeWidth,
          ),
        ),
      ),
    );
  }
}

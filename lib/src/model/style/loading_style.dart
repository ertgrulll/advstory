import 'package:advstory/src/view/default_components/advstory_tray.dart';
import 'package:flutter/material.dart';

/// Loading indicator styles. AdvStory creates a rotated indicator using this
/// styles.
///
/// Basically, indicator is the same as [AdvStoryTray] border effect.
class LoadingStyle {
  /// Creates styles for the loading screen.
  ///
  /// Background color is `Color(0xFFFDFBF9)` for light theme and
  /// `Color(0xFF1B1B1B)` for dark theme.
  const LoadingStyle({
    this.backgroundColor,
    this.strokeWidth = 7,
    this.fillDuration = const Duration(seconds: 3),
    this.gradientColors = const [
      Color(0xCC4b689c),
      Color(0x00000000),
    ],
    this.colorStops,
    this.size = 50,
  });

  /// Background color of the loading screen.
  final Color? backgroundColor;

  /// Indicator gradient colors.
  ///
  /// ___
  /// _Tip: use [Colors.transparent] for last color to showing rotation
  /// effect nicely._
  final List<Color> gradientColors;

  /// Gradient color stops.
  final List<double>? colorStops;

  /// Indicator completion duration from zero to end.
  final Duration fillDuration;

  /// Indicator size.
  final double size;

  /// Indicator stroke width.
  final double strokeWidth;
}

import 'package:flutter/material.dart';

class ShimmerStyle {
  const ShimmerStyle({
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFFFFFFF),
  });

  /// Background color of the shimmer effect.
  final Color baseColor;

  /// Color of the shimmer effect.
  final Color highlightColor;
}

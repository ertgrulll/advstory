import 'package:advstory/advstory.dart';
import 'package:flutter/material.dart';

/// Loading shimmer styles.
class ShimmerStyle {
  /// Creates styles for the shimmer that shown when [AdvStoryTray] and
  /// [StoryHeader] images are loading.
  const ShimmerStyle({
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFFFFFFF),
  });

  /// Background color of the shimmer effect.
  final Color baseColor;

  /// Color of the shimmer effect.
  final Color highlightColor;
}

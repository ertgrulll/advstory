import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/model/style/shimmer_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

/// Shimmer effect shown when default components images are getting ready
/// to show.
class Shimmer extends StatelessWidget {
  /// Creates a shimmer loading screen.
  const Shimmer({
    required this.style,
    Key? key,
  }) : super(key: key);

  /// Style for the shimmer effect.
  final ShimmerStyle style;

  @override
  Widget build(BuildContext context) {
    return shimmer.Shimmer.fromColors(
      baseColor: style.baseColor,
      highlightColor: style.highlightColor,
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: style.baseColor,
      ),
    );
  }
}

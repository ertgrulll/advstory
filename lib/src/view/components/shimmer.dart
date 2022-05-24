import 'package:advstory/src/model/models.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

class Shimmer extends StatelessWidget {
  /// Creates a placeholder shimmer effect while media files loading.
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

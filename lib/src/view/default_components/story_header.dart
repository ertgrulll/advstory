import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/view/components/shimmer.dart';
import 'package:flutter/material.dart';

/// This widget is predefined header for stories. Shows user profile picture and
/// name in a row.
class StoryHeader extends StatelessWidget {
  /// Creates a story header.
  const StoryHeader({
    required this.url,
    required this.text,
    this.shimmerStyle = const ShimmerStyle(),
    Key? key,
  }) : super(key: key);

  /// Image url for the user profile picture.
  final String url;

  /// Most probably a text for the user name.
  final String text;

  /// Style for the shimmer effect.
  final ShimmerStyle shimmerStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipOval(
              child: Image.network(
                url,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return frame != null
                      ? TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 500),
                          builder: (BuildContext context, double opacity, _) {
                            return Opacity(opacity: opacity, child: child);
                          },
                        )
                      : Shimmer(style: shimmerStyle);
                },
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

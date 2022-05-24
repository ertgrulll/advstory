import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/view/components/shimmer.dart';
import 'package:flutter/material.dart';

/// Upper section for a cluster or story.
class ClusterHeader extends StatelessWidget {
  /// Creates a widget to displaying profile picture and a text in a horizontal
  /// layout.
  const ClusterHeader({
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
                  return Icon(
                    Icons.error,
                    color: shimmerStyle.baseColor,
                  );
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

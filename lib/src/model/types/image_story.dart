import 'package:advstory/src/model/types/story.dart';
import 'package:flutter/material.dart';

/// Data model for image stories.
class ImageStory extends ManagedStory {
  /// Holds the data to be used to create the image story.
  ///
  /// [url], media source url.
  /// [requestHeaders] used when fetching media file if provided.
  /// [cacheKey] is a key to use when caching media file. Useful if the url has
  /// parameters like a timestamp, token etc.
  const ImageStory({
    required String url,
    Map<String, String>? requestHeaders,
    String? cacheKey,
    Widget? header,
    Widget? footer,
  }) : super(
          url: url,
          cacheKey: cacheKey,
          requestHeaders: requestHeaders,
          footer: footer,
          header: header,
        );
}

import 'package:advstory/src/model/models.dart';
import 'package:flutter/material.dart';

/// Base class for story types.
abstract class Story {
  const Story({
    this.header,
    this.footer,
  });

  /// Upper section of the story.
  final Widget? header;

  /// Bottom section of the story.
  final Widget? footer;
}

/// Base class for [ImageStory] and [VideoStory].
abstract class ManagedStory extends Story {
  const ManagedStory({
    Widget? header,
    Widget? footer,
    required this.url,
    this.requestHeaders,
    this.cacheKey,
  }) : super(header: header, footer: footer);

  /// Media source url.
  final String url;

  /// Headers to use when getting the media file.
  final Map<String, String>? requestHeaders;

  /// Key to use when caching media file. Useful if the url has parameters
  /// like a timestamp, token etc.
  final String? cacheKey;
}

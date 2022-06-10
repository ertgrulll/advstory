import 'dart:async';

import 'package:advstory/src/model/story.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// View for video contents.
class VideoContent extends ManagedContent {
  /// Creates a video view. Video content skip duration is video duration by
  /// default and cannot be changed.
  ///
  /// - `url`: Media source url.
  /// - `requestHeaders`: Headers to use when getting the media file.
  /// - `cacheKey`: Key to use when caching media file. Useful if the url has
  /// parameters like timestamp, token etc.
  /// - `header`: Upper section of the content. This header overrides the
  /// header provided to [Story]. If this is null, [Story] header is used.
  /// - `footer`: Bottom section of the content. This footer overrides the
  /// footer provided to [Story]. If this is null, [Story] footer is used.
  /// - `timeout`: Time limit to prepare this content.
  /// - `errorBuilder`: Builder to create error view to show when media couldn't
  /// loaded in [timeout].
  ///
  /// ---
  /// If you want to create a video story with different duration, you can
  /// create a custom content class by extending [StoryContent].
  const VideoContent({
    required String url,
    Map<String, String>? requestHeaders,
    String? cacheKey,
    Widget? header,
    Widget? footer,
    Duration? timeout,
    Widget Function()? errorBuilder,
    Key? key,
  }) : super(
          url: url,
          cacheKey: cacheKey,
          requestHeaders: requestHeaders,
          header: header,
          footer: footer,
          timeout: timeout,
          errorBuiler: errorBuilder,
          key: key,
        );

  @override
  StoryContentState<VideoContent> createState() => _VideoContentState();
}

/// State class for video content.
class _VideoContentState extends StoryContentState<VideoContent> {
  VideoPlayerController? _videoController;
  bool _hasError = false;

  @override
  Future<void> initContent() async {
    if (widget.timeout != null) setTimeout(widget.timeout!);

    final file = await loadFile(
      url: widget.url,
      cacheKey: widget.cacheKey,
      requestHeaders: widget.requestHeaders,
    );

    if (!mounted) return;
    final controller = VideoPlayerController.file(file);
    await controller.initialize();

    if (!mounted) return;
    setState(() {
      _videoController = controller;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      markReady(duration: controller.value.duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && widget.errorBuiler != null) {
      return widget.errorBuiler!.call();
    }

    if (_videoController?.value.isInitialized == true) {
      return Center(
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    return shouldShowLoading ? loadingScreen : const SizedBox();
  }

  @override
  void onStart() {
    _videoController?.play();
  }

  @override
  onResume() {
    _videoController?.play();
  }

  @override
  void onPause() {
    _videoController?.pause();
  }

  @override
  void onStop() {
    _videoController?.pause();
    _videoController?.seekTo(Duration.zero);
  }

  @override
  void onTimeout() {
    setState(() {
      _hasError = true;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}

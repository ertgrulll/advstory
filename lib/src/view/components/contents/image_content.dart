import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Image story content.
class ImageContent extends ManagedContent {
  /// Creates an image content.
  ///
  /// - `url`: media source url.
  /// - `duration`: skip duration of the content.
  /// - `requestHeaders`: headers to use when getting the media file.
  /// - `cacheKey`: Key to use when caching media file. Useful if the url has
  /// parameters like timestamp, token etc.
  /// - `header`: Upper section of the content. This header overrides the
  /// header provided to [Story]. If this is null, [Story] header is used.
  /// - `footer`: Bottom section of the content. This footer overrides the
  /// footer provided to [Story]. If this is null, [Story] footer is used.
  /// - `timeout`: Time limit to prepare this content.
  /// - `errorBuilder`: Builder to create error view to show when media couldn't
  /// loaded in [timeout].
  const ImageContent({
    required String url,
    this.duration = const Duration(seconds: 10),
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

  /// Skip duration of the content.
  final Duration duration;

  @override
  StoryContentState<ImageContent> createState() => _ImageContentState();
}

/// State class for image content.
class _ImageContentState extends StoryContentState<ImageContent> {
  ImageProvider? _imageProvider;
  bool _hasError = false;

  @override
  Future<void> initContent() async {
    if (widget.timeout != null) setTimeout(widget.timeout!);

    final file = await loadFile(
      url: widget.url,
      cacheKey: widget.cacheKey,
      requestHeaders: widget.requestHeaders,
    );
    final imageProvider = FileImage(file);

    if (!mounted) return;
    await precacheImage(imageProvider, context);

    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      markReady(duration: widget.duration);
    });
    setState(() {
      _imageProvider = imageProvider;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && widget.errorBuiler != null) {
      return widget.errorBuiler!.call();
    }

    if (_imageProvider != null) {
      return Container(
        constraints: const BoxConstraints.expand(),
        child: Image(
          image: _imageProvider!,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return wasSynchronouslyLoaded
                ? child
                : AnimatedOpacity(
                    opacity: frame != null ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                  );
          },
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      );
    }

    return shouldShowLoading ? loadingScreen : const SizedBox();
  }

  @override
  void onTimeout() {
    setState(() {
      _hasError = true;
    });
  }
}

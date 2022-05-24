import 'package:advstory/src/controller/story_controller_impl.dart';
import 'package:advstory/src/model/story_position.dart';
import 'package:advstory/src/model/story_resource.dart';
import 'package:advstory/src/util/cron.dart';
import 'package:advstory/src/view/components/items/image_item.dart';
import 'package:advstory/src/view/components/items/video_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Manages cron and indicators of cluster.
class FlowManager {
  FlowManager({
    required this.duration,
    required this.callback,
  });

  /// Media resources for [ImageItem] and [VideoItem].
  final _resources = <StoryPosition, StoryResource>{};

  /// Duration to skip to the next story.
  final Duration duration;

  /// This is always [AdvStoryControllerImpl]'s _nextStory_ function.
  /// Stories always go through forward automatically.
  final VoidCallback callback;

  /// Last known story position.
  StoryPosition? lastPosition;

  /// Indicator controller which is setting from [AdvStoryControllerImpl].
  late AnimationController indicatorController;

  final _cron = Cron();

  /// Returns `true` if a flow is runnig, and `false` if it's not.
  bool get isRunning => _cron.isRunning;

  /// Starts story skip flow and sets indicators.
  Future<void> start(StoryPosition position) async {
    await reset();

    lastPosition = position;

    if (_currentResource != null) {
      _currentResource!.isLoaded.value
          ? _startFlow()
          : _currentResource!.isLoaded.addListener(_startFlow);
    } else {
      _startFlow();
    }
  }

  /// Pauses cron and active indicator.
  void pause() {
    _cron.pause();
    indicatorController.stop(canceled: false);

    final resource = _currentResource;

    if (resource is VideoResource) {
      resource.videoController?.pause();
    }
  }

  /// Resumes cron and active indicator.
  void resume() {
    _cron.resume();
    indicatorController.forward();

    final resource = _currentResource;

    if (resource is VideoResource) {
      resource.videoController?.play();
    }
  }

  /// Resets cron and indicator animation. Also stops and resets progress of
  /// video player
  Future<void> reset() async {
    if (lastPosition == null) return;

    final resource = _currentResource;
    resource?.isLoaded.removeListener(_startFlow);
    _cron.stop();

    if (resource is VideoResource) {
      await resource.videoController?.pause();
      await resource.videoController?.seekTo(Duration.zero);
    }

    indicatorController.reset();
    lastPosition = null;
  }

  /// Inserts [resource] to the [_resources] map.
  void addResource(StoryResource resource, StoryPosition position) =>
      _resources[position] = resource;

  /// Disposes and removes value from resources.
  void removeResource(StoryPosition position) {
    final resource = _resources[position];

    if (resource is VideoResource) {
      resource.videoController?.dispose();
    }

    _resources.remove(position);
  }

  /// Returns [StoryResource] for given [StoryPosition].
  T? getResource<T extends StoryResource>(StoryPosition position) =>
      _resources[position] as T?;

  /// Returns current story video controller if it's a video.
  VideoPlayerController? get videoController {
    final resource = _currentResource;

    if (resource is VideoResource) {
      return resource.videoController;
    }

    return null;
  }

  void _startFlow() {
    late final Duration duration;
    final resource = _currentResource;

    if (resource is VideoResource) {
      final vidCon = resource.videoController!;
      duration = vidCon.value.duration;
      vidCon.play();
    } else {
      duration = this.duration;
    }

    _setIndicator(duration);
    _cron.start(
      onComplete: callback,
      duration: duration,
    );

    resource?.isLoaded.removeListener(_startFlow);
  }

  void _setIndicator(Duration duration) => indicatorController
    ..duration = duration
    ..forward();

  StoryResource? get _currentResource => _resources[lastPosition!];
}

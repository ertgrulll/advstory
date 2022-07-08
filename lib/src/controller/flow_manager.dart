import 'dart:async';

import 'package:advstory/src/controller/advstory_controller_impl.dart';
import 'package:advstory/src/model/story_position.dart';
import 'package:advstory/src/util/cron.dart';
import 'package:flutter/material.dart';

/// Manages cron and indicators of story.
class FlowManager {
  /// Creates a [FlowManager] with [callback] that called when the time is up.
  FlowManager({required this.callback});

  /// This is always [AdvStoryControllerImpl]'s _nextStory_ method.
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
  Future<void> start(StoryPosition position, Duration duration) async {
    if (_cron.isRunning) reset();

    lastPosition = position;
    _setIndicator(duration);
    _cron.start(
      onComplete: callback,
      duration: duration,
    );
  }

  /// Pauses cron and active indicator.
  void pause() {
    _cron.pause();
    indicatorController.stop(canceled: false);
  }

  /// Resumes cron and active indicator.
  void resume() {
    if (indicatorController.duration != null) {
      _cron.resume();
      indicatorController.forward();
    }
  }

  /// Resets cron and indicator animation. Also stops and resets progress of
  /// video player
  void reset() async {
    if (lastPosition == null) return;

    _cron.stop();
    indicatorController.reset();
    lastPosition = null;
  }

  void _setIndicator(Duration duration) => indicatorController
    ..duration = duration
    ..forward();
}

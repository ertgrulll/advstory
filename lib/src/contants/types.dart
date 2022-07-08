import 'dart:async';

import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:advstory/src/view/components/tray/animated_tray.dart';
import 'package:flutter/material.dart';

/// The builder function that will be called to build story content.
typedef ContentBuilder = AdvStoryContent Function(int contentIndex);

/// The builder function that will be called to build a [Story].
typedef StoryBuilder = FutureOr<Story> Function(int storyIndex);

/// Generator function to be called to create a tray for story with
/// the given index.
///
/// You can use any widget for non-animated tray. AdvStory directly uses
/// your widget as tray.
///
/// To create a custom animated tray, create a widget that extends
/// [AnimatedTray].
typedef TrayBuilder = Widget Function(int storyIndex);

/// Callback that will be called when the story tray animation should
/// start and stop.
typedef AnimationNotifierCallback = void Function(bool shouldAnimate);

/// Callback for story events.
///
/// Invokes on:
/// * On a tray tap.
/// * On a story skipped or closed.
/// * On a content skipped.
/// * On pause
/// * On resume
typedef StoryEventCallback = FutureOr<void> Function(
  /// Event type
  StoryEvent event,

  /// Current story and content index in the story
  StoryPosition position,
);

/// Story event interceptor definition.
typedef Interceptor = FutureOr<void> Function()? Function(StoryEvent);

/// Tray tap event interceptor definition.
typedef TrayTapInterceptor = StoryPosition? Function(int trayIndex);

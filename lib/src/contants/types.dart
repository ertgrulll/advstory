import 'dart:async';

import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/view/components/async_page_view.dart';
import 'package:advstory/src/view/components/tray/animated_tray.dart';
import 'package:flutter/material.dart';

/// The builder function that will be called to build [ImageStory], [VideoStory]
/// or [WidgetStory].
typedef StoryBuilder = Story Function(int storyIndex);

/// The builder function that will be called to build a [Cluster].
typedef ClusterBuilder = FutureOr<Cluster> Function(int clusterIndex);

/// Generator function to be called to create a tray for cluster with
/// the given index.
///
/// You can use any widget as tray for non-animated tray. AdvStory directly uses
/// your widget as tray.
///
/// To create a custom animated tray, create a widget that extends
/// [AnimatedTray].
typedef TrayBuilder = Widget Function(int clusterIndex);

/// Callback that will be called when the story tray animation should
/// start and stop.
typedef AnimationNotifierCallback = void Function(bool shouldAnimate);

/// Callback for story events.
///
/// Invokes on:
/// * On a tray tap.
/// * On a cluster skipped or closed.
/// * On a story skipped.
/// * On pause
/// * On resume
typedef StoryEventCallback = FutureOr<void> Function(
  /// Event type
  StoryEvent event,

  /// Contains current cluster and story index in cluster
  StoryPosition position,
);

/// Widget builder function definition for [AsyncPageView].
typedef AsyncIndexedWidgetBuilder = Future<Widget> Function(
  BuildContext context,
  int index,
);

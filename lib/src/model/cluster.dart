import 'package:advstory/advstory.dart';
import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:flutter/material.dart';

/// A cluster is a group of stories that keeps all of a user's stories together.
/// This class keeps the data of a cluster.
class Cluster {
  /// The data that used to create a story group.
  Cluster({
    required this.storyCount,
    required this.storyBuilder,
    this.header,
    this.footer,
  });

  /// Function that will be called to build a [Story].
  ///
  /// May be called multiple times. Do not make heavy calculations in this
  /// method to avoid performance issues.
  final StoryBuilder storyBuilder;

  /// The number of stories in this cluster.
  final int storyCount;

  /// Cluster's top section.
  /// Most probably cluster owner's profile picture and name.
  ///
  /// If null, the cluster's top section will be empty.
  /// You can use default [ClusterHeader].
  final Widget? header;

  /// Cluster's bottom section.
  /// Most probably buttons and other custom controls.
  ///
  /// If null, the cluster's bottom section will be empty.
  final Widget? footer;
}

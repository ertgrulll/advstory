import 'package:advstory/src/advstory.dart';
import 'package:advstory/src/model/style/indicator_style.dart';
import 'package:advstory/src/model/style/shimmer_style.dart';
import 'package:advstory/src/model/style/tray_style.dart';
import 'package:advstory/src/view/components/shimmer.dart';
import 'package:flutter/material.dart';

/// General styles for the [AdvStory].
class AdvStoryStyle {
  /// General styles for the [AdvStory].
  const AdvStoryStyle({
    this.indicatorStyle = const IndicatorStyle(),
    this.trayStyle = const TrayStyle(),
    this.shimmerStyle = const ShimmerStyle(),
    this.loadingScreen,
  });

  /// Story progress indicator style.
  final IndicatorStyle indicatorStyle;

  /// Custom loading screen widget.
  /// This is useful if you want to use your own loading screen.
  ///
  /// If not set, shimmer effect will be use as default.
  final Widget? loadingScreen;

  /// Styles for tray list.
  final TrayStyle trayStyle;

  /// Colors for shimmer effect. This is shown when tray images are loading.
  final ShimmerStyle shimmerStyle;

  /// Shortcut for loading screen.
  ///
  /// Returns loading screen if provided, otherwise returns default loading
  /// screen with given or default styles.
  Widget call() {
    return loadingScreen ?? Shimmer(style: shimmerStyle);
  }
}

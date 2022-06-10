import 'package:advstory/src/advstory.dart';
import 'package:advstory/src/model/style/indicator_style.dart';
import 'package:advstory/src/model/style/loading_style.dart';
import 'package:advstory/src/model/style/tray_list_style.dart';
import 'package:advstory/src/view/components/loading_indicator.dart';
import 'package:flutter/material.dart';

/// Styles for the [AdvStory].
class AdvStoryStyle {
  /// Creates styles to use in the [AdvStory].
  const AdvStoryStyle({
    this.indicatorStyle = const IndicatorStyle(),
    this.trayListStyle = const TrayListStyle(),
    this.loadingStyle = const LoadingStyle(),
    this.loadingScreen,
    this.hideBars = true,
  });

  /// Story progress indicator style.
  final IndicatorStyle indicatorStyle;

  /// Custom loading screen widget.
  /// This is useful when you want to use your own loading screen.
  ///
  /// If not set, [LoadingIndicator] will be use as default.
  final Widget? loadingScreen;

  /// Style for default loading screen.
  final LoadingStyle loadingStyle;

  /// Styles for tray list.
  final TrayListStyle trayListStyle;

  /// Sets the story view to be full screen or not. Default value is `true`.
  /// Hides status and navigation bars when story view opened.
  ///
  /// _Setting this to false may cause unexpected resizing of the contents._
  final bool hideBars;

  /// Shortcut for loading screen.
  ///
  /// Returns loading screen if provided, otherwise returns default loading
  /// screen with provided or default styles.
  Widget call() => loadingScreen ?? LoadingIndicator(style: loadingStyle);
}

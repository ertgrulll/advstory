import 'dart:async';

import 'package:advstory/src/controller/advstory_controller_impl.dart';
import 'package:advstory/src/model/style/advstory_style.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/util/position_notifier.dart';
import 'package:flutter/material.dart';

/// Wraps story view and provides required data to the views.
class DataProvider extends InheritedWidget {
  /// Creates data provider.
  const DataProvider({
    Key? key,
    required Widget child,
    required this.controller,
    required this.style,
    required this.buildHelper,
    required this.preloadContent,
    required this.preloadStory,
    this.hasTrays = true,
    this.firstContentPreperation,
  }) : super(key: key, child: child);

  /// Used to determine if AdvStory widget created for only player or not.
  final bool hasTrays;

  /// Story view uses this variable to setting allowImplicitScrolling.
  final bool preloadStory;

  /// Content view uses this variable to setting allowImplicitScrolling.
  final bool preloadContent;

  /// Provided or default controller.
  final AdvStoryControllerImpl controller;

  /// Styles to use when creating views.
  final AdvStoryStyle style;

  /// Helper utility for building stories.
  final BuildHelper buildHelper;

  /// If an animated tray provided, AdvStory provides this variable and awaits
  /// this future to open the story view. First content completes future when
  /// is ready to show.
  final Completer<void>? firstContentPreperation;

  /// First content's markReady method calls this method to allow AdvStory to
  /// show the story view.
  void markFirstReady() {
    if (firstContentPreperation != null &&
        !firstContentPreperation!.isCompleted) {
      firstContentPreperation!.complete();
    }
  }

  /// Current position details of the story view. Story contents uses this to
  /// determine if it should start or not.
  ///
  /// When [DataProvider] created, controller always has [PositionNotifier].
  PositionNotifier get positionNotifier => controller.positionNotifier;

  /// Returns the [DataProvider] from the [BuildContext].
  static DataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>();
  }

  @override
  bool updateShouldNotify(DataProvider oldWidget) => false;
}

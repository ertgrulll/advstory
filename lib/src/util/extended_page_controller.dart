import 'package:flutter/material.dart';

/// Only stores [itemCount] as an extra.
class ExtendedPageController extends PageController {
  /// Creates a [ExtendedPageController] instance.
  ExtendedPageController({
    required this.itemCount,
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) : super(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

  /// The number of items in the PageView.
  final int itemCount;
}

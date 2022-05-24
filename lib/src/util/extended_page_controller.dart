import 'package:flutter/material.dart';

/// Only stores [itemCount] as an extra.
class ExtendedPageController extends PageController {
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

  final int itemCount;
}

import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/util/extended_page_controller.dart';
import 'package:flutter/material.dart';

/// A pageview supporting async page builder.
class AsyncPageView extends StatelessWidget {
  /// Creates an instance of [AsyncPageView].
  const AsyncPageView({
    required this.allowImplicitScrolling,
    required this.itemBuilder,
    required this.loadingScreen,
    required this.controller,
    required this.onPageChanged,
    required this.itemCount,
    Key? key,
  }) : super(key: key);

  /// Whether to allow implicit scrolling.
  final bool allowImplicitScrolling;

  /// PageView controller
  final ExtendedPageController controller;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  final AsyncIndexedWidgetBuilder itemBuilder;

  /// A widget to create the loading screen.
  final Widget loadingScreen;

  /// The number of items in the page view.
  final int itemCount;

  Widget _widgetBuilder(BuildContext context, int index) {
    final ValueNotifier<Widget> content = ValueNotifier(loadingScreen);

    itemBuilder.call(context, index).then((value) {
      content.value = value;
    });

    return ValueListenableBuilder<Widget>(
      valueListenable: content,
      builder: (context, value, child) => value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      allowImplicitScrolling: allowImplicitScrolling,
      controller: controller,
      itemBuilder: _widgetBuilder,
      onPageChanged: onPageChanged,
      itemCount: itemCount,
      key: key,
    );
  }
}

import 'dart:async';

import 'package:advstory/src/contants/types.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final PageController _defaultPageController = PageController();

/// A pageview supporting async page builder.
class AsyncPageView extends StatefulWidget {
  AsyncPageView({
    required this.itemBuilder,
    required this.loadingScreen,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.onPageDisposed,
    this.itemCount,
    this.restorationId,
    this.scrollBehavior,
    this.padEnds = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    Key? key,
    PageController? controller,
  })  : controller = controller ?? _defaultPageController,
        super(key: key);

  /// Called when a page removed from the pageview's cache.
  final FutureOr<void> Function(int index)? onPageDisposed;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Whether the page view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the page view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the page view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this page
  /// view is scrolled.
  final PageController controller;

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  ///
  /// If the [padEnds] is false and [PageController.viewportFraction] < 1.0,
  /// the page will snap to the beginning of the viewport; otherwise, the page
  /// will snap to the center of the viewport.
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  final AsyncIndexedWidgetBuilder itemBuilder;

  /// A widget to create the loading screen.
  final Widget loadingScreen;

  final int? itemCount;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  ///
  /// The [ScrollBehavior] of the inherited [ScrollConfiguration] will be
  /// modified by default to not apply a [Scrollbar].
  final ScrollBehavior? scrollBehavior;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is set to true and [PageController.viewportFraction] < 1.0, padding will be added
  /// such that the first and last child slivers will be in the center of
  /// the viewport when scrolled all the way to the start or end, respectively.
  ///
  /// If [PageController.viewportFraction] >= 1.0, this property has no effect.
  ///
  /// This property defaults to true and must not be null.
  final bool padEnds;

  @override
  AsyncPageViewState createState() => AsyncPageViewState();
}

class AsyncPageViewState extends State<AsyncPageView> {
  final List<int> builtPageIndexes = [];
  late int currentPage = widget.controller.initialPage;

  void _callback() {
    final rounded = widget.controller.page?.round();

    if (rounded == null) return;

    if (rounded != currentPage) {
      if (rounded - 2 >= 0 && builtPageIndexes.contains(rounded - 2)) {
        widget.onPageDisposed?.call(rounded - 2);
        builtPageIndexes.remove(rounded - 2);
      } else if (widget.itemCount != null &&
          rounded + 2 <= widget.itemCount! - 1 &&
          builtPageIndexes.contains(rounded + 2)) {
        widget.onPageDisposed?.call(rounded + 2);
        builtPageIndexes.remove(rounded + 2);
      }
    }

    currentPage = rounded;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_callback);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_callback);
    super.dispose();
  }

  Widget _widgetBuilder(BuildContext context, int index) {
    final ValueNotifier<Widget> content = ValueNotifier(widget.loadingScreen);

    widget.itemBuilder.call(context, index).then((value) {
      content.value = value;
    });

    builtPageIndexes.add(index);

    return ValueListenableBuilder<Widget>(
      valueListenable: content,
      builder: (context, value, child) {
        return value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      allowImplicitScrolling: true,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      dragStartBehavior: widget.dragStartBehavior,
      scrollBehavior: widget.scrollBehavior,
      clipBehavior: widget.clipBehavior,
      itemBuilder: _widgetBuilder,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.itemCount,
      key: widget.key,
      padEnds: widget.padEnds,
      restorationId: widget.restorationId,
    );
  }
}

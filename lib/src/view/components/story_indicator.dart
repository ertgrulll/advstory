import 'package:advstory/src/model/style/indicator_style.dart';
import 'package:advstory/src/view/content_view.dart';
import 'package:flutter/material.dart';

/// Indicator view for the [ContentView]
class StoryIndicator extends StatelessWidget {
  /// Creates indicators for the every content in the story.
  ///
  /// Indicators before [activeIndicatorIndex] will be filled with
  /// [IndicatorStyle]' valueColor and the rest will be filled with
  /// with  backgroundColor.
  StoryIndicator({
    required this.count,
    required this.activeIndicatorIndex,
    required this.controller,
    required this.style,
    Key? key,
  }) : super(key: key);

  StoryIndicator.placeholder({
    required this.count,
    required this.style,
    Key? key,
  })  : activeIndicatorIndex = -1,
        controller = null,
        super(key: key);

  /// Indicator progress controller.
  final AnimationController? controller;

  /// The number of indicators to display.
  final int count;

  /// Currently viewed story index. This index is filled with [IndicatorStyle]'s
  /// valueColor and animation is applied.
  final int activeIndicatorIndex;

  /// Style of the indicators.
  final IndicatorStyle style;

  /// Indicators to show.
  final List<Widget> _indicators = [];

  void _generateIndicators() {
    final animation = controller != null
        ? Tween<double>(begin: 0.0, end: 1.0).animate(controller!)
        : null;
    if (_indicators.isNotEmpty) return;

    final indicators = List<Widget>.generate(
      count,
      (index) {
        if (index != activeIndicatorIndex) {
          final isBefore = index < activeIndicatorIndex;
          return Expanded(
            child: LinearProgressIndicator(
              backgroundColor: style.backgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                isBefore ? style.valueColor : style.backgroundColor,
              ),
              value: isBefore ? 1 : 0,
              minHeight: style.height,
            ),
          );
        } else {
          return Expanded(
            child: AnimatedBuilder(
              animation: animation!,
              builder: (context, child) {
                return LinearProgressIndicator(
                  backgroundColor: style.backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(style.valueColor),
                  value: animation.value,
                  minHeight: style.height,
                );
              },
            ),
          );
        }
      },
    );

    for (int i = 1; i < indicators.length; i++) {
      if (i % 2 != 0) {
        indicators.insert(i, SizedBox(width: style.spacing));
      }
    }

    _indicators.addAll(indicators);
  }

  @override
  Widget build(BuildContext context) {
    _generateIndicators();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: style.padding,
        child: SizedBox(
          width: double.maxFinite,
          height: style.height,
          child: Row(children: _indicators),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TrayStyle {
  /// Styles for tray list
  const TrayStyle({
    this.direction = Axis.horizontal,
    this.spacing = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
  });

  /// Tray list direction. Trays can be stacked vertically or horizontally.
  final Axis direction;

  /// Space between tray items. This value is not affects padding between tray
  /// list and screen edges.
  final double spacing;

  /// Space between tray list and parent widget.
  final EdgeInsets padding;
}

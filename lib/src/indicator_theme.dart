import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timelines/src/indicators.dart';
import 'package:timelines/src/timeline_node.dart';

import 'timeline_theme.dart';

/// Defines the visual properties of [DotIndicator], indicators inside [TimelineNode]s.
///
/// Descendant widgets obtain the current [IndicatorThemeData] object using `IndicatorTheme.of(context)`. Instances of
/// [IndicatorThemeData] can be customized with [IndicatorThemeData.copyWith].
///
/// Typically a [IndicatorThemeData] is specified as part of the overall [TimelineTheme] with
/// [TimelineThemeData.indicatorTheme].
///
/// All [IndicatorThemeData] properties are `null` by default. When null, the widgets will provide their own defaults.
///
/// See also:
///
///  * [TimelineThemeData], which describes the overall theme information for the timeline.
@immutable
class IndicatorThemeData with Diagnosticable {
  /// Creates a theme that can be used for [IndicatorTheme] or
  /// [TimelineThemeData.indicatorTheme].
  const IndicatorThemeData({
    this.color,
    this.size,
  });

  /// The color of [DotIndicator]s and indicators inside [TimelineNode]s, and so forth.
  final Color color;

  /// The size of [DotIndicator]s and indicators inside [TimelineNode]s, and so forth in logical pixels.
  ///
  /// Indicators occupy a square with width and height equal to size.
  final double size;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  IndicatorThemeData copyWith({
    Color color,
    double size,
  }) {
    return IndicatorThemeData(
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  /// Linearly interpolate between two Indicator themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static IndicatorThemeData lerp(IndicatorThemeData a, IndicatorThemeData b, double t) {
    assert(t != null);
    return IndicatorThemeData(
      color: Color.lerp(a?.color, b?.color, t),
      size: lerpDouble(a?.size, b?.size, t),
    );
  }

  @override
  int get hashCode => hashValues(color, size);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is IndicatorThemeData && other.color == color && other.size == size;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(DoubleProperty('size', size, defaultValue: null));
  }
}

/// Controls the default color and size of indicators in a widget subtree.
///
/// The indicator theme is honored by [TimelineNode], [DotIndicator] and [TO DO] widgets.
class IndicatorTheme extends InheritedTheme {
  /// Creates an indicator theme that controls the color and size for [DotIndicator]s, indicators inside [TimelineNode]s.
  const IndicatorTheme({
    Key key,
    @required this.data,
    Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  /// The properties for descendant [DotIndicator]s, indicators inside [TimelineNode]s.
  final IndicatorThemeData data;

  /// The data from the closest instance of this class that encloses the given context.
  ///
  /// Defaults to the current [TimelineThemeData.indicatorTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  ///  IndicatorThemeData theme = IndicatorTheme.of(context);
  /// ```
  static IndicatorThemeData of(BuildContext context) {
    final IndicatorTheme indicatorTheme = context.dependOnInheritedWidgetOfExactType<IndicatorTheme>();
    return indicatorTheme?.data ?? TimelineTheme.of(context).indicatorTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final IndicatorTheme ancestorTheme = context.findAncestorWidgetOfExactType<IndicatorTheme>();
    return identical(this, ancestorTheme) ? child : IndicatorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(IndicatorTheme oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    data.debugFillProperties(properties);
  }
}

mixin ThemedIndicatorComponent on Widget {
  Color get color;
  Color getEffectiveColor(BuildContext context) {
    return this.color ?? IndicatorTheme.of(context).color ?? TimelineTheme.of(context).color;
  }

  double get size;
  double getEffectiveSize(BuildContext context) {
    return this.size ?? IndicatorTheme.of(context).size ?? 15.0;
  }
}

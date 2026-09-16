import 'package:flutter/material.dart';
import '../models/coastal_log.dart';

class TideData {
  final double tidePhaseProgress; // 0.0 - 1.0
  final double currentHeightM;
  final List<CoastalLog> logs;

  TideData({
    required this.tidePhaseProgress,
    required this.currentHeightM,
    required this.logs,
  });
}

class TideScope extends InheritedWidget {
  final TideData data;

  const TideScope({
    super.key,
    required this.data,
    required super.child,
  });

  static TideData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TideScope>();
    if (scope == null) throw Exception('No TideScope found in context');
    return scope.data;
  }

  @override
  bool updateShouldNotify(covariant TideScope oldWidget) {
    return oldWidget.data.tidePhaseProgress != data.tidePhaseProgress ||
        oldWidget.data.currentHeightM != data.currentHeightM ||
        oldWidget.data.logs.length != data.logs.length;
  }
}

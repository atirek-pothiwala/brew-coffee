import 'package:flutter/material.dart';

/// Layout constants aligned with [espresso_machine_flat.svg] viewBox 400×300.
abstract final class MachinePourLayout {
  static const double artAspect = 400 / 300;

  /// Spout center in normalized SVG coordinates (0–1).
  static const double nozzleX = 200 / 400;
  static const double nozzleY = 218 / 300;

  static const double machineWidth = 360;
  static double machineHeight = machineWidth / artAspect;

  /// Vertical gap (px) between machine art bottom and cup stack top.
  static const double cupGap = 8;

  static const double cupWidth = 150;
}

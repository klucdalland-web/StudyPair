import 'package:flutter/painting.dart';

/// Espacements cohérents pour StudyPair.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double huge = 48;

  static const EdgeInsets page = EdgeInsets.all(xl);
  static const EdgeInsets pageH = EdgeInsets.symmetric(horizontal: xl);
}

import 'package:flutter/material.dart';

/// Rayons cohérents avec le design StudyPair.
///
/// Exemple :
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     color: AppColors.surface,
///     borderRadius: AppRadii.lgAll, // 16
///   ),
/// )
///
/// ClipRRect(borderRadius: AppRadii.pillAll, child: ...)
/// ```
abstract class AppRadii {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

import 'package:flutter/material.dart';

/// Palette StudyPair (extrait du design FigJam).
///
/// Exemple :
/// ```dart
/// Container(color: AppColors.primary)
/// Text('Hello', style: TextStyle(color: AppColors.textSecondary))
/// Icon(Icons.star, color: AppColors.star)
/// ```
abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF4B45B3);
  static const Color primaryDark = Color(0xFF3A3590);
  static const Color primarySoft = Color(0xFFEBEAF8);
  static const Color primaryMuted = Color(0xFFC8C5EA);

  // Surfaces
  static const Color background = Color(0xFFF7F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF0EFF8);
  static const Color border = Color(0xFFE4E3F0);
  static const Color divider = Color(0xFFEEEEF5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B80);
  static const Color textTertiary = Color(0xFF9A9AAD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textLink = Color(0xFF4B45B3);

  // Status
  static const Color success = Color(0xFF1F9D6A);
  static const Color successSoft = Color(0xFFE6F7F0);
  static const Color warning = Color(0xFFE8A317);
  static const Color warningSoft = Color(0xFFFFF6E0);
  static const Color danger = Color(0xFFE04545);
  static const Color dangerSoft = Color(0xFFFDECEC);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSoft = Color(0xFFEAF2FE);

  // Accents
  static const Color star = Color(0xFFF5B400);
  static const Color online = Color(0xFF22C55E);
  static const Color chatIncoming = Color(0xFFF1F1F6);
  static const Color progressTrack = Color(0xFFEBEAF8);
  static const Color progressFill = Color(0xFF4B45B3);

  // Shadows
  static const Color shadow = Color(0x1A1A1A2E);

  // Inputs
  static const Color inputBackground = Color(0xFFEFF4FF);

  // Icones
  static const Color blueIcon = Color(0xFFD3E4FE);
}

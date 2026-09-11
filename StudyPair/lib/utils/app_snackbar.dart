import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'error_message.dart';

/// Snackbars / toasts StudyPair.
///
/// Exemple :
/// ```dart
/// AppSnackbar.success('Binôme validé');
/// AppSnackbar.error(e);
/// AppSnackbar.info('3 nouvelles suggestions');
/// AppSnackbar.warning('Limite de 6 messages atteinte');
/// ```
abstract class AppSnackbar {
  static void success(String message, {String title = 'OK'}) {
    _show(
      title: title,
      message: message,
      background: AppColors.success,
      icon: Icons.check_circle_rounded,
    );
  }

  static void error(Object error, {String title = 'Erreur'}) {
    _show(
      title: title,
      message: ErrorMessage.from(error),
      background: AppColors.danger,
      icon: Icons.error_rounded,
      duration: const Duration(seconds: 4),
    );
  }

  static void info(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      background: AppColors.primary,
      icon: Icons.info_rounded,
    );
  }

  static void warning(String message, {String title = 'Attention'}) {
    _show(
      title: title,
      message: message,
      background: AppColors.warning,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color background,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: background,
      colorText: AppColors.textOnPrimary,
      margin: const EdgeInsets.all(12),
      borderRadius: AppRadii.md,
      duration: duration,
      icon: Icon(icon, color: AppColors.textOnPrimary),
      shouldIconPulse: false,
    );
  }
}

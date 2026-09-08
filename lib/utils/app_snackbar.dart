import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'error_message.dart';

/// Snackbars GetX centralisées.
abstract class AppSnackbar {
  static void success(String message, {String title = 'OK'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  static void error(Object error, {String title = 'Erreur'}) {
    Get.snackbar(
      title,
      ErrorMessage.from(error),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
    );
  }

  static void info(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }
}

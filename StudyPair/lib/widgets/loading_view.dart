import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_spacing.dart';

bool get _isCupertino =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

/// Loader adaptatif : Cupertino sur iOS, Material sur Android.
///
/// Exemple :
/// ```dart
/// const AppLoader()
/// const AppLoader(size: 32, color: AppColors.primary)
/// ```
class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color,
    this.size = 24,
    this.strokeWidth = 2.5,
  });

  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;

    if (_isCupertino) {
      return SizedBox(
        width: size,
        height: size,
        child: CupertinoActivityIndicator(color: c, radius: size / 2.2),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: c,
      ),
    );
  }
}

/// Écran / zone de chargement centrée.
///
/// Exemple :
/// ```dart
/// if (controller.loading.value) {
///   return const LoadingView(message: 'Chargement des matchs…');
/// }
/// ```
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoader(size: 28),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

/// Petit spinner pour boutons (20×20).
///
/// Exemple :
/// ```dart
/// ElevatedButton(
///   onPressed: null,
///   child: ButtonSpinner(color: AppColors.textOnPrimary),
/// )
/// ```
class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      size: 20,
      strokeWidth: 2,
      color: color ?? AppColors.textOnPrimary,
    );
  }
}

/// Switch adaptatif.
///
/// Exemple :
/// ```dart
/// AppSwitch(
///   value: _notifications,
///   onChanged: (v) => setState(() => _notifications = v),
/// )
/// ```
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary,
      );
    }
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.surface,
      activeTrackColor: AppColors.primary,
    );
  }
}

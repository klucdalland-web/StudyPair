import 'package:flutter/material.dart';

import 'package:study_pair/widgets/app_text.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'loading_view.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// Bouton StudyPair avec plusieurs variantes :
/// primary, secondary, ghost et danger.
///
/// Supporte également :
/// - un état de chargement
/// - une couleur de fond personnalisée
/// - une couleur de texte personnalisée
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = true,
    this.height = 48,
    this.backgroundColor,
    this.textColor,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.expanded = true,
    this.height = 48,
    this.backgroundColor,
    this.textColor,
  }) : outlined = true,
       variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.expanded = false,
    this.height = 40,
    this.backgroundColor,
    this.textColor,
  }) : outlined = false,
       variant = AppButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expanded;
  final double height;

  /// Couleur de fond personnalisée du bouton.
  final Color? backgroundColor;

  /// Couleur du texte et des icônes.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveVariant = outlined && variant == AppButtonVariant.primary
        ? AppButtonVariant.secondary
        : variant;

    final handler = loading ? null : onPressed;

    final defaultTextColor = switch (effectiveVariant) {
      AppButtonVariant.primary => AppColors.textOnPrimary,
      AppButtonVariant.secondary => AppColors.primary,
      AppButtonVariant.ghost => AppColors.primary,
      AppButtonVariant.danger => AppColors.textOnPrimary,
    };

    final effectiveTextColor = textColor ?? defaultTextColor;

    final spinnerColor = effectiveTextColor;

    final Widget child = loading
        ? ButtonSpinner(color: spinnerColor)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: effectiveTextColor),
                const SizedBox(width: 8),
              ],
              AppText(label, color: effectiveTextColor),
            ],
          );

    final Widget button = switch (effectiveVariant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: effectiveTextColor,
          minimumSize: Size(expanded ? double.infinity : 0, height),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 20),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
        ),
        child: child,
      ),

      AppButtonVariant.secondary => ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? AppColors.primarySoft,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: AppColors.surfaceAlt,
          disabledForegroundColor: AppColors.textTertiary,
          minimumSize: Size(expanded ? double.infinity : 0, height),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 20),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
        ),
        child: child,
      ),

      AppButtonVariant.ghost => TextButton(
        onPressed: handler,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: effectiveTextColor,
          minimumSize: Size(expanded ? double.infinity : 0, height),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 12),
        ),
        child: child,
      ),

      AppButtonVariant.danger => ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? AppColors.danger,
          foregroundColor: effectiveTextColor,
          minimumSize: Size(expanded ? double.infinity : 0, height),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 20),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
        ),
        child: child,
      ),
    };

    return button;
  }
}

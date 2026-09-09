import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'loading_view.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// Bouton StudyPair (plein, soft, ghost, danger) avec état loading.
///
/// Exemple :
/// ```dart
/// AppButton(
///   label: 'Se connecter',
///   loading: _loading,
///   onPressed: _submit,
/// )
///
/// AppButton.secondary(
///   label: 'Continuer avec Google',
///   onPressed: _google,
/// )
///
/// AppButton.ghost(
///   label: 'Mot de passe oublié ?',
///   onPressed: _reset,
/// )
///
/// AppButton(
///   label: 'Supprimer',
///   variant: AppButtonVariant.danger,
///   icon: Icons.delete_outline,
///   onPressed: _delete,
/// )
/// ```
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
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.expanded = true,
    this.height = 48,
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

  @override
  Widget build(BuildContext context) {
    final effectiveVariant = outlined && variant == AppButtonVariant.primary
        ? AppButtonVariant.secondary
        : variant;
    final handler = loading ? null : onPressed;

    final child = loading
        ? ButtonSpinner(
            color: effectiveVariant == AppButtonVariant.primary ||
                    effectiveVariant == AppButtonVariant.danger
                ? AppColors.textOnPrimary
                : AppColors.primary,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final button = switch (effectiveVariant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: handler,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(expanded ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 20),
          ),
          child: child,
        ),
      AppButtonVariant.secondary => ElevatedButton(
          onPressed: handler,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primarySoft,
            foregroundColor: AppColors.primary,
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
            minimumSize: Size(expanded ? double.infinity : 0, height),
            padding: EdgeInsets.symmetric(horizontal: expanded ? 16 : 12),
          ),
          child: child,
        ),
      AppButtonVariant.danger => ElevatedButton(
          onPressed: handler,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.danger,
            foregroundColor: AppColors.textOnPrimary,
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

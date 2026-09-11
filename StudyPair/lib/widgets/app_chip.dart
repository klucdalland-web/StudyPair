import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_text.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

enum AppChipVariant { soft, solid, outline, success, warning }

/// Tag / filtre StudyPair (matières, statuts, filtres).
///
/// Exemple :
/// ```dart
/// Wrap(
///   spacing: 8,
///   children: [
///     AppChip(label: 'Python'),
///     AppChip(label: 'Tous', selected: true, onTap: () {}),
///     AppChip(label: 'Acceptée', variant: AppChipVariant.success),
///     AppChip(label: 'Informatique', variant: AppChipVariant.outline, onTap: () {}),
///   ],
/// )
/// ```
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.variant = AppChipVariant.soft,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final AppChipVariant variant;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final bg = switch (variant) {
      AppChipVariant.soft =>
        selected ? AppColors.primary : AppColors.primarySoft,
      AppChipVariant.solid => AppColors.primary,
      AppChipVariant.outline => AppColors.surface,
      AppChipVariant.success => AppColors.successSoft,
      AppChipVariant.warning => AppColors.warningSoft,
    };

    final fg = switch (variant) {
      AppChipVariant.soft =>
        selected ? AppColors.textOnPrimary : AppColors.primary,
      AppChipVariant.solid => AppColors.textOnPrimary,
      AppChipVariant.outline => AppColors.textSecondary,
      AppChipVariant.success => AppColors.success,
      AppChipVariant.warning => AppColors.warning,
    };

    final border = variant == AppChipVariant.outline
        ? Border.all(color: AppColors.border)
        : null;

    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.smAll,
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 6)],
          AppText(label, color: fg, fontSize: 12, fontWeight: FontWeight.w600),
        ],
      ),
    );

    if (onTap == null) return child;

    return GestureDetector(onTap: onTap, child: child);
  }
}

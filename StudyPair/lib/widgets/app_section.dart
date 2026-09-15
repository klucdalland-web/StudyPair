import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'gap.dart';

/// Titre de section + action optionnelle (« Tout voir »).
///
/// Exemple :
/// ```dart
/// AppSectionHeader(
///   title: 'Suggestions du jour',
///   actionLabel: 'Tout voir',
///   onAction: () => Get.toNamed(Routes.match),
/// )
/// ```
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

/// Barre de progression fine (demandes actives, messages 4/6…).
///
/// Exemple :
/// ```dart
/// // 4 messages sur 6
/// AppProgressBar(value: 4 / 6)
///
/// Text('2/3 demandes actives'),
/// AppProgressBar(value: 2 / 3, height: 8),
/// ```
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 6,
  });

  /// 0.0 → 1.0
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pillAll,
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppColors.progressTrack,
        color: AppColors.progressFill,
      ),
    );
  }
}

/// Badge de statut (Acceptée, En ligne…).
///
/// Exemple :
/// ```dart
/// AppStatusBadge(label: 'Acceptée')
/// AppStatusBadge(label: 'En attente', tone: AppStatusTone.warning)
/// AppStatusBadge(label: 'Refusée', tone: AppStatusTone.danger)
/// ```
class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    this.tone = AppStatusTone.success,
  });

  final String label;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      AppStatusTone.success => (AppColors.successSoft, AppColors.success),
      AppStatusTone.warning => (AppColors.warningSoft, AppColors.warning),
      AppStatusTone.danger => (AppColors.dangerSoft, AppColors.danger),
      AppStatusTone.info => (AppColors.infoSoft, AppColors.info),
      AppStatusTone.neutral => (AppColors.surfaceAlt, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.xsAll,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum AppStatusTone { success, warning, danger, info, neutral }

/// Note étoile (ex. 4.9).
///
/// Exemple :
/// ```dart
/// AppRating(value: 4.9)
/// ```
class AppRating extends StatelessWidget {
  const AppRating({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
        const HGap.sm(),
        Text(
          value.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

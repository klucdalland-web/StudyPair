import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../utils/app_spacing.dart';

/// Carte blanche StudyPair (bordure légère, coins 16).
///
/// Exemple :
/// ```dart
/// AppCard(
///   onTap: () => Get.toNamed(Routes.profile),
///   child: Column(
///     crossAxisAlignment: CrossAxisAlignment.start,
///     children: [
///       Text('Sarah Legrand', style: Theme.of(context).textTheme.titleMedium),
///       Text('Data Engineer • Doctolib'),
///     ],
///   ),
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color = AppColors.surface,
    this.borderColor = AppColors.border,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color color;
  final Color borderColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgAll,
        child: content,
      ),
    );
  }
}

/// Carte soft (fond lavande) pour suggestions / highlight.
///
/// Exemple :
/// ```dart
/// AppSoftCard(
///   child: Text('2/3 demandes actives'),
/// )
/// ```
class AppSoftCard extends StatelessWidget {
  const AppSoftCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primarySoft,
      borderColor: Colors.transparent,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

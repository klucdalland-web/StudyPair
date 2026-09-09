import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Avatar circulaire StudyPair (option point online).
///
/// Exemple :
/// ```dart
/// AppAvatar(
///   imageUrl: user.photoUrl,
///   name: 'Sarah Legrand',
///   size: 48,
///   online: true,
///   onTap: () => Get.toNamed(Routes.profile),
/// )
///
/// // Fallback initiales si pas d'image :
/// AppAvatar(name: 'Yanis K.', size: 40)
/// ```
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 44,
    this.online,
    this.onTap,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final bool? online;
  final VoidCallback? onTap;

  String get _initials {
    final value = (name ?? '').trim();
    if (value.isEmpty) return '?';
    final parts = value.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySoft,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) => _fallback,
              errorWidget: (_, _, _) => _fallback,
            )
          : _fallback,
    );

    final withStatus = online == null
        ? avatar
        : SizedBox(
            width: size,
            height: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                avatar,
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: size * 0.28,
                    height: size * 0.28,
                    decoration: BoxDecoration(
                      color: online! ? AppColors.online : AppColors.textTertiary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          );

    if (onTap == null) return withStatus;
    return GestureDetector(onTap: onTap, child: withStatus);
  }

  Widget get _fallback => Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.34,
          ),
        ),
      );
}

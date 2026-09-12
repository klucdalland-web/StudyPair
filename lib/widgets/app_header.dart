import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.label,
    this.showAvatar = true,
    this.avatarUrl,
    this.hasUnreadNotifications = false,
    this.onNotificationsTap,
    this.onAvatarTap,
    this.icon = Icons.school_outlined,
  });

  final String label;
  final bool showAvatar;

  final String? avatarUrl;
  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onAvatarTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const HGap.sm(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'StudyPair',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                AppText(label, fontSize: 12, color: AppColors.textSecondary),
              ],
            ),
          ),
          _NotificationButton(
            hasUnread: hasUnreadNotifications,
            onTap: onNotificationsTap,
          ),
          if (showAvatar) ...[
            const HGap.sm(),
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.border,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.hasUnread, this.onTap});

  final bool hasUnread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          if (hasUnread)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8455A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

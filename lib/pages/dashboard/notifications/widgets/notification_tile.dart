import 'package:flutter/material.dart';

import '../../../../models/notification_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/gap.dart';

const Map<String, ({IconData icon, Color color})> _typeStyles = {
  'demande': (icon: Icons.mail_outline_rounded, color: Color(0xFF605CF4)),
  'etudiant': (icon: Icons.school_outlined, color: Color(0xFFA11647)),
  'creneau': (icon: Icons.schedule_outlined, color: Color(0xFF4391FF)),
};

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, this.onTap});

  final NotificationModel notification;
  final VoidCallback? onTap;

  ({IconData icon, Color color}) get _style =>
      _typeStyles[notification.typeId] ??
      (icon: Icons.notifications_outlined, color: AppColors.primary);

  String get _timeAgo {
    final date = notification.createdAt;
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "à l'instant";
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'il y a ${diff.inDays} j';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.surface
              : AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: style.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(style.icon, size: 22, color: AppColors.textOnPrimary),
            ),
            const HGap.sm(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          notification.typeLabel,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          height: 8,
                          width: 8,
                          margin: const EdgeInsets.only(left: 8, top: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    notification.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    _timeAgo,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

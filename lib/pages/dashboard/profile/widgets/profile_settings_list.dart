import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_card.dart';
import 'package:study_pair/widgets/app_section.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList({
    super.key,
    required this.onAvailabilityTap,
    required this.onDiplomaTap,
    required this.onNotificationsTap,
    required this.onPrivacyTap,
  });

  final VoidCallback onAvailabilityTap;
  final VoidCallback onDiplomaTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          onTap: onAvailabilityTap,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const HGap.md(),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Disponibilités',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    VGap.xs(),
                    AppText(
                      '4 créneaux ouverts cette semaine',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
        const VGap.xl(),
        const AppSectionHeader(title: 'Compte & préférences'),
        const VGap.md(),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.school_outlined,
                title: 'Diplôme MIAGE Sorbonne vérifié',
                onTap: onDiplomaTap,
              ),
              const Divider(
                height: 1,
                indent: 60,
                endIndent: 20,
                color: AppColors.divider,
              ),
              _SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications & Rappels',
                onTap: onNotificationsTap,
              ),
              const Divider(
                height: 1,
                indent: 60,
                endIndent: 20,
                color: AppColors.divider,
              ),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                title: 'Confidentialité & Sécurité',
                onTap: onPrivacyTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: AppText(
        title,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
      ),
    );
  }
}

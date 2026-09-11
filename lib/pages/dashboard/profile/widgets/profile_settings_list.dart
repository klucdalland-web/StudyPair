import 'package:flutter/material.dart';

import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileSettingsList extends StatelessWidget {
  final VoidCallback onAvailabilityTap;
  final VoidCallback onDiplomaTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onPrivacyTap;

  const ProfileSettingsList({
    super.key,
    required this.onAvailabilityTap,
    required this.onDiplomaTap,
    required this.onNotificationsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carte Disponibilités
        _buildCard(
          onTap: onAvailabilityTap,
          child: Row(
            children: [
              _buildIconContainer(
                Icons.calendar_today_rounded,
                const Color(0xFFE0E7FF),
                const Color(0xFF4F46E5),
              ),
              HGap.md(),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Disponibilités',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                    VGap.xs(),
                    AppText(
                      '4 créneaux ouverts cette semaine',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),

        VGap.xl(),

        // Titre Compte & Préférences
        const AppText(
          'COMPTE & PRÉFÉRENCES',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9CA3AF),
        ),

        VGap.md(),

        // Carte regroupant les préférences
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.school_outlined,
                  title: 'Diplôme MIAGE Sorbonne vérifié',
                  onTap: onDiplomaTap,
                ),
                const Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 20,
                  color: Color(0xFFF3F4F6),
                ),
                _buildListItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications & Rappels',
                  onTap: onNotificationsTap,
                ),
                const Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 20,
                  color: Color(0xFFF3F4F6),
                ),
                _buildListItem(
                  icon: Icons.lock_outline_rounded,
                  title: 'Confidentialité & Sécurité',
                  onTap: onPrivacyTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required VoidCallback onTap, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: child,
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: const Color(0xFF4F46E5), size: 22),
      title: AppText(
        title,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1F2937),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

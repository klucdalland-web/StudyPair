import 'package:flutter/material.dart';
import 'package:study_pair/pages/auth/register/widgets/profile_card.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileSelector extends StatelessWidget {
  final bool isStudentSelected;
  final ValueChanged<bool> onProfileSelected;

  const ProfileSelector({
    super.key,
    required this.isStudentSelected,
    required this.onProfileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              'Choisissez votre profil',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ],
        ),
        const VGap.md(),

        // Carte Étudiant
        ProfileCard(
          isSelected: isStudentSelected,
          onTap: () => onProfileSelected(true),
          title: 'Je suis Étudiant(e)',
          badgeText: 'Mentoré',
          badgeColor: Colors.blue.shade50,
          badgeTextColor: Colors.blue.shade800,
          description: 'Je cherche un mentor pour m\'orienter, préparer mes candidatures et réviser mes examens en toute confiance.',
          features: [
            _FeatureItem(
              icon: Icons.folder_shared_outlined,
              color: Colors.blue.shade800,
              text: 'Accès aux fiches pairs',
            ),
            _FeatureItem(
              icon: Icons.people_outline,
              color: Colors.blue.shade800,
              text: 'Binômes d\'étude',
            ),
          ],
        ),
        const VGap.md(),

        // Carte Mentor
        ProfileCard(
          isSelected: !isStudentSelected,
          onTap: () => onProfileSelected(false),
          title: 'Je suis Mentor',
          badgeText: 'Certification',
          badgeColor: Colors.green.shade50,
          badgeTextColor: Colors.green.shade800,
          description: 'Je souhaite accompagner des pairs, transmettre mon expérience de promo et valoriser mon engagement académique.',
          features: [
            _FeatureItem(
              icon: Icons.workspace_premium_outlined,
              color: Colors.green.shade800,
              text: 'Badge certifié',
            ),
            _FeatureItem(
              icon: Icons.trending_up,
              color: Colors.green.shade800,
              text: 'Attestation d\'heures',
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const HGap.xs(),
        AppText(text, fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.school, color: Colors.white, size: 32),
        ),
        const VGap.md(),

        // Badge Réseau
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, size: 14, color: AppColors.primary),
              const HGap.xs(),
              const AppText(
                'Réseau d\'entraide universitaire certifié',
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        const VGap.md(),

        // Titres
        const AppText(
          'Rejoindre StudyPair',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        const VGap.xs(),
        const AppText(
          'Créez votre compte académique',
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
        const VGap.xl(),

        // Stepper (Indicateur d'étapes)
        Row(
          children: [
            // Étape 1
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AppText(
                  '1',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const HGap.sm(),
            const AppText(
              'Compte',
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),

            // Ligne de connexion
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(color: Colors.grey, thickness: 1),
              ),
            ),

            // Étape 2
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AppText(
                  '2',
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const HGap.sm(),
            const AppText('Infos personnelles', color: AppColors.textSecondary),
          ],
        ),
      ],
    );
  }
}

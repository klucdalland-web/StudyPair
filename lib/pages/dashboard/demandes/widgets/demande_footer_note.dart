import 'package:flutter/material.dart';

import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class DemandesFooterNote extends StatelessWidget {
  const DemandesFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            size: 18,
            color: AppColors.textSecondary,
          ),

          const VGap.xs(),

          AppText(
            'Les demandes expirent automatiquement après 5 jours sans réponse.',
            fontSize: 12,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),

          const VGap.xs(),

          AppText(
            'Un engagement rapide renforce la réputation de votre profil StudyPair.',
            fontSize: 12,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:study_pair/widgets/gap.dart';

import '../../../../theme/app_colors.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge Mentorat
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Mentorat académique d\'excellence',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const VGap.md(),
        // Titre principal
        Text(
          'Réussissez ensemble vos études supérieures.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const VGap.md(),
        // Sous-titre
        Text(
          'Le mentorat d\'excellence entre pairs d\'universités et grandes écoles, calibré pour vos objectifs.',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    );
  }
}

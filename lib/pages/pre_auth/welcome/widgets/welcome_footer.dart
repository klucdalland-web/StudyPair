import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';

class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Inscription réservée aux étudiants munis d\'un email institutionnel (.edu, .univ)',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }
}

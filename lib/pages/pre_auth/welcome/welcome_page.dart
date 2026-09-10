import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/pre_auth/welcome/widgets/feature_card.dart';
import 'package:study_pair/pages/pre_auth/welcome/widgets/social_proof.dart';
import 'package:study_pair/pages/pre_auth/welcome/widgets/welcome_footer.dart';
import 'package:study_pair/pages/pre_auth/welcome/widgets/welcome_header.dart';
import 'package:study_pair/pages/pre_auth/welcome/widgets/welcome_hero.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/gap.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeHeader(),
            const VGap.xxl(),
            const WelcomeHero(),
            const VGap.xxl(),

            // Section "Pourquoi StudyPair ?"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Pourquoi StudyPair ?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Cadre universitaire certifié',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const VGap.md(),

            // Cartes de fonctionnalités
            const FeatureCard(
              icon: Icons.manage_accounts_outlined,
              title: 'Matching Intelligent',
              description:
                  'Calibré par disciplines, filières et ambitions académiques.',
            ),
            const VGap.md(),
            const FeatureCard(
              icon: Icons.forum_outlined,
              title: 'Cadrage Garanti',
              description: 'Phase exploratoire sécurisée de 6 messages avant validation mutuelle.',
            ),
            const VGap.md(),
            const FeatureCard(
              icon: Icons.settings_suggest_outlined,
              title: 'Réseau Vérifié',
              description: 'Étudiants et alumni vérifiés via adresse email institutionnel.',
            ),

            const VGap.xxl(),
            const SocialProof(),
            const VGap.xl(),

            // Boutons d'action
            AppButton(
              label: 'Créer un compte',
              onPressed: () => Get.toNamed(Routes.register),
            ),
            const VGap.md(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.toNamed(Routes.login),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Se connecter',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const VGap.xl(),
            const WelcomeFooter(),
            const VGap.xl(),
          ],
        ),
      ),
    );
  }
}

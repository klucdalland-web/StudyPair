import 'package:flutter/material.dart';

import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Logo(),

        const VGap.lg(),

        const _Badge(),

        const VGap.sm(),

        const AppText(
          'Bon retour !',
          textAlign: TextAlign.center,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),

        const VGap.sm(),

        const AppText(
          "Connectez-vous à votre espace\nacadémique d'excellence.",
          textAlign: TextAlign.center,
          color: AppColors.textSecondary,
          fontSize: 15,
          height: 1.4,
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),

        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.check, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),

          const HGap.sm(),

          const AppText(
            'RÉSEAU PAIR-À-PAIR UNIVERSITAIRE',
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            height: 1,
          ),
        ],
      ),
    );
  }
}

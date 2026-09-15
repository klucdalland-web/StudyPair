import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/theme/app_colors.dart';

import '../../../../routes/app_routes.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppText(
          'Déjà inscrit ? ',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.login),
          child: const AppText(
            'Se connecter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

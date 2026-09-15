import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key, required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          'Pas encore de compte ? ',
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        GestureDetector(
          onTap: onRegister,
          child: AppText(
            "S'inscrire",
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

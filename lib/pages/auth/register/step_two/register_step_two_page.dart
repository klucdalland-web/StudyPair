import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/auth/register/step_two/register_step_two_controller.dart';
import 'package:study_pair/pages/auth/register/step_two/widgets/mentor_form.dart';
import 'package:study_pair/pages/auth/register/step_two/widgets/register_step_header.dart';
import 'package:study_pair/pages/auth/register/step_two/widgets/student_form.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/gap.dart';

class RegisterStepTwoPage extends StatelessWidget {
  final bool isStudent;

  const RegisterStepTwoPage({super.key, required this.isStudent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterStepTwoController());

    return AppScaffold(
      body: Column(
        children: [
          // En-tête personnalisé
          RegisterStepHeader(
            title: isStudent ? 'Inscription Étudiant' : 'Inscription Mentor',
            subtitle: isStudent ? 'Besoins d\'accompagnement' : 'Finalisation',
            stepText: 'Étape 2 sur 2',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: isStudent
                  ? StudentForm(controller: controller)
                  : MentorForm(controller: controller),
            ),
          ),

          // Bouton de soumission en bas
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                AppButton(
                  label: isStudent
                      ? 'Finaliser mon inscription'
                      : 'Valider et devenir Mentor',
                  onPressed: controller.submitForm,
                  icon: isStudent
                      ? Icons.arrow_forward
                      : Icons.check_circle_outline,
                ),
                const VGap.sm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const HGap.xs(),
                    Flexible(
                      child: AppText(
                        isStudent
                            ? 'Vos informations permettront de vous matcher avec le bon mentor.'
                            : 'Badge Mentor Certifié attribué après examen sous 24h.',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

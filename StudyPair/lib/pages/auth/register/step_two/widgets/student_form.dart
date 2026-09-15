import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:study_pair/pages/auth/register/step_two/register_step_two_controller.dart';
import 'package:study_pair/pages/auth/register/step_two/widgets/section_header.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../widgets/app_chip.dart';
import '../../../../../widgets/app_text.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/gap.dart';

class StudentForm extends StatelessWidget {
  final RegisterStepTwoController controller;

  const StudentForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Personnalisons votre binôme',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    const VGap.xs(),
                    const AppText(
                      'Complétez vos préférences pour un jumelage académique sur-mesure.',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const HGap.md(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        const VGap.xl(),

        // Informations académiques
        const SectionHeader(
          icon: Icons.account_balance_outlined,
          title: 'Informations académiques',
        ),

        const VGap.md(),

        const AppText(
          'Établissement ou Université',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),

        const VGap.sm(),

        AppTextField(
          controller: controller.establishmentController,
          hint: 'Université Paris-Saclay',
          prefixIcon: const Icon(Icons.business_outlined, size: 20),
        ),

        const VGap.md(),

        const AppText(
          'Filière / Cursus d’études',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),

        const VGap.sm(),

        AppTextField(
          controller: controller.specialtyController,
          hint: 'Licence Informatique & Mathématiques',
          prefixIcon: const Icon(Icons.book_outlined, size: 20),
        ),

        const VGap.md(),

        const AppText(
          'Niveau universitaire actuel',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),

        const VGap.sm(),

        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['L1', 'L2', 'L3', 'M1', 'M2', 'Autre'].map((level) {
              return AppChip(
                label: level,
                selected: controller.studentLevel.value == level,
                onTap: () {
                  controller.updateStudentLevel(level);
                },
              );
            }).toList(),
          ),
        ),

        const VGap.xl(),

        // Matières & Compétences prioritaires
        const SectionHeader(
          icon: Icons.lightbulb_outline,
          title: 'Matières & Compétences prioritaires',
        ),

        const VGap.md(),

        AppTextField(
          controller: controller.subjectController,
          hint: 'Ajouter une matière (ex: Algèbre linéaire)',
          prefixIcon: const Icon(Icons.search, size: 20),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _addSubject();
          },
        ),

        const VGap.sm(),

        // Bouton avec largeur contrôlée
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addSubject,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: const AppText(
              'Ajouter la matière',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const VGap.md(),

        const AppText(
          'MATIÈRES SÉLECTIONNÉES',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),

        const VGap.sm(),

        Obx(
          () => controller.selectedSubjects.isEmpty
              ? const AppText(
                  'Aucune matière sélectionnée',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.selectedSubjects.map((subject) {
                    return AppChip(
                      label: subject,
                      selected: true,
                      onTap: () {
                        controller.toggleSubject(subject);
                      },
                      leading: const Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.textOnPrimary,
                      ),
                    );
                  }).toList(),
                ),
        ),

        const VGap.sm(),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Bases de données', 'Prépa examens'].map((subject) {
            return AppChip(
              label: subject,
              selected: false,
              onTap: () {
                controller.toggleSubject(subject);
              },
              leading: const Icon(
                Icons.add,
                size: 14,
                color: AppColors.primary,
              ),
            );
          }).toList(),
        ),

        const VGap.xl(),

        //  Objectifs
        const SectionHeader(
          icon: Icons.flag_outlined,
          title: 'Vos objectifs d’apprentissage',
        ),

        const VGap.md(),

        _buildCheckbox(controller, 'Comprendre les cours & TD'),

        _buildCheckbox(controller, 'Méthodologie & organisation'),

        _buildCheckbox(controller, 'Préparation aux partiels'),

        _buildCheckbox(controller, 'Projet de fin d’année'),

        const VGap.xl(),

        // Disponibilités & Rythme
        const SectionHeader(
          icon: Icons.calendar_today_outlined,
          title: 'Rythme & Disponibilités souhaitées',
        ),

        const VGap.md(),

        const AppText(
          'Fréquence idéale',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),

        const VGap.sm(),

        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['1h / semaine', '2h / semaine', 'Ponctuel'].map((
              frequency,
            ) {
              return AppChip(
                label: frequency,
                selected: controller.studentFrequency.value == frequency,
                onTap: () {
                  controller.studentFrequency.value = frequency;
                },
              );
            }).toList(),
          ),
        ),

        const VGap.md(),

        const AppText(
          'Moments propices',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),

        const VGap.sm(),

        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Soir en semaine', 'Mercredi après-midi', 'Week-end']
                .map((moment) {
                  return AppChip(
                    label: moment,
                    selected: controller.studentMoment.value == moment,
                    onTap: () {
                      controller.studentMoment.value = moment;
                    },
                  );
                })
                .toList(),
          ),
        ),

        const VGap.xl(),

        // Description & Présentation du besoin
        const SectionHeader(
          icon: Icons.edit_note_outlined,
          title: 'Description & Présentation du besoin',
        ),

        const VGap.md(),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              AppTextField(
                controller: controller.studentDescriptionController,
                hint: 'Décrivez brièvement vos attentes, vos points de blocage ou vos objectifs avec votre futur mentor...',
                maxLines: 4,
              ),

              const VGap.sm(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        HGap.xs(),
                        Flexible(
                          child: AppText(
                            'Recommandé pour un jumelage sur-mesure',
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const HGap.sm(),
                  const AppText(
                    '0 / 300',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),

        const VGap.xxl(),
      ],
    );
  }

  void _addSubject() {
    final subject = controller.subjectController.text.trim();

    if (subject.isEmpty) return;

    if (!controller.selectedSubjects.contains(subject)) {
      controller.toggleSubject(subject);
    }

    controller.subjectController.clear();
  }

  Widget _buildCheckbox(RegisterStepTwoController controller, String title) {
    return Obx(() {
      final isChecked = controller.selectedObjectives.contains(title);

      return GestureDetector(
        onTap: () {
          controller.toggleObjective(title);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isChecked
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                color: isChecked ? AppColors.primary : Colors.grey.shade400,
                size: 20,
              ),
              const HGap.md(),
              Expanded(
                child: AppText(
                  title,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

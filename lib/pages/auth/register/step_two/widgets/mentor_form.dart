import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/auth/register/step_two/register_step_two_controller.dart';
import 'package:study_pair/pages/auth/register/step_two/widgets/section_header.dart';
import 'package:study_pair/utils/validators.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../widgets/app_chip.dart';
import '../../../../../widgets/app_text.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/gap.dart';

class MentorForm extends StatelessWidget {
  final RegisterStepTwoController controller;

  const MentorForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Partagez vos expertises académiques et définissez vos préférences de tutorat.',
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
        const VGap.xl(),

        // Section 1: Cursus & Statut
        const SectionHeader(
          icon: Icons.school_outlined,
          title: 'Cursus & Statut',
        ),
        const VGap.md(),
        const AppText(
          'Niveau d\'études actuel',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        const VGap.sm(),

        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.mentorLevel.value,
                isExpanded: true,
                items:
                    const ['Sélectionnez votre niveau', 'M1', 'M2', 'Doctorat']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: AppText(e, fontSize: 13),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  if (val != null) controller.mentorLevel.value = val;
                },
              ),
            ),
          ),
        ),
        const VGap.md(),

        const AppText(
          'Etablissement & Spécialité',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        const VGap.sm(),
        AppTextField(
          controller: controller.establishmentController,
          hint: 'Ex. Télécom Paris, Sorbonne Université...',
          textInputAction: TextInputAction.next,
          validator: (value) =>
              Validators.required(value, 'L\'établissement et la spécialité'),
        ),
        const VGap.md(),
        const AppText(
          'Vérification académique (optionnelle)',
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
        const VGap.sm(),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.verified_user_outlined, size: 16),
                label: const AppText('Attestation', fontSize: 12),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const HGap.sm(),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.link, size: 16),
                label: const AppText('Lier LinkedIn', fontSize: 12),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const VGap.xl(),

        // Section 2: Domaines d'expertise
        const SectionHeader(
          icon: Icons.psychology_outlined,
          title: 'Domaines d\'expertise',
          trailing: AppText(
            'Tutorat ciblé',
            fontSize: 10,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        const VGap.md(),

        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.selectedExpertises.map((exp) {
              return AppChip(
                label: exp,
                selected: true,
                onTap: () => controller.toggleExpertise(exp),
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
          children:
              [
                'Machine Learning',
                'Web Fullstack',
                'Méthodologie & Rédaction',
              ].map((exp) {
                return AppChip(
                  label: exp,
                  selected: false,
                  onTap: () => controller.toggleExpertise(exp),
                );
              }).toList(),
        ),
        const VGap.md(),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: controller.expertiseController,
                hint: 'Ajouter une autre compétence...',
              ),
            ),
            const HGap.sm(),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: () {
                  final expertise = controller.expertiseController.text.trim();
                  if (expertise.isEmpty) return;
                  controller.toggleExpertise(expertise);
                  controller.expertiseController.clear();
                },
              ),
            ),
          ],
        ),
        const VGap.xl(),

        // Section 3: Approche du mentorat
        const SectionHeader(
          icon: Icons.lightbulb_outline,
          title: 'Approche du mentorat',
        ),
        const VGap.md(),
        const AppText(
          'Présentation & Disponibilités',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        const VGap.sm(),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              AppTextField(
                controller: controller.presentationController,
                hint:
                    'Expliquez en 2-3 phrases comment vous aimez accompagner vos binômes, vos créneaux et votre méthode...',
                maxLines: 4,
                validator: (value) =>
                    Validators.minLength(value, 20, 'La présentation'),
              ),
              const VGap.sm(),
              const Align(
                alignment: Alignment.centerRight,
                child: AppText(
                  '0 / 250',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const VGap.xl(),

        // Section 4: Capacité & Modalités
        const SectionHeader(
          icon: Icons.people_outline,
          title: 'Capacité & Modalités',
        ),
        const VGap.md(),
        const AppText(
          'Étudiants accompagnés en simultané',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        const VGap.sm(),
        Obx(
          () => Row(
            children: ['1 binôme', '2 binômes', '3 max'].map((cap) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AppChip(
                  label: cap,
                  selected: controller.mentorCapacity.value == cap,
                  onTap: () => controller.updateMentorCapacity(cap),
                ),
              );
            }).toList(),
          ),
        ),
        const VGap.md(),
        const AppText(
          'Format préféré',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        const VGap.sm(),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: _formatChip(
                  label: 'Visio',
                  icon: Icons.videocam_outlined,
                  selected: controller.mentorFormat.value == 'Visio',
                  onTap: () => controller.updateMentorFormat('Visio'),
                ),
              ),
              const HGap.sm(),
              Expanded(
                child: _formatChip(
                  label: 'Campus',
                  icon: Icons.location_on_outlined,
                  selected: controller.mentorFormat.value == 'Campus',
                  onTap: () => controller.updateMentorFormat('Campus'),
                ),
              ),
              const HGap.sm(),
              Expanded(
                child: _formatChip(
                  label: 'Mixte',
                  icon: Icons.shuffle,
                  selected: controller.mentorFormat.value == 'Mixte',
                  onTap: () => controller.updateMentorFormat('Mixte'),
                ),
              ),
            ],
          ),
        ),
        const VGap.xxl(),
      ],
      ),
    );
  }

  Widget _formatChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AppChip(
      label: label,
      selected: selected,
      onTap: onTap,
      leading: Icon(
        icon,
        size: 14,
        color: selected ? AppColors.textOnPrimary : AppColors.primary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_chip.dart';
import 'package:study_pair/widgets/app_section.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileExpertise extends StatelessWidget {
  const ProfileExpertise({
    super.key,
    required this.skills,
    required this.onEdit,
  });

  final List<String> skills;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'Expertise',
          actionLabel: 'Modifier',
          onAction: onEdit,
        ),
        const VGap.md(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (skills.isEmpty)
              const AppChip(
                label: 'Aucune expertise',
                variant: AppChipVariant.outline,
              )
            else
              for (final skill in skills)
                AppChip(
                  label: skill,
                  variant: AppChipVariant.outline,
                ),
          ],
        ),
      ],
    );
  }
}

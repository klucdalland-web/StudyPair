import 'package:flutter/material.dart';

import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileExpertise extends StatelessWidget {
  final List<String> skills;
  final VoidCallback onEdit;

  const ProfileExpertise({
    super.key,
    required this.skills,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              'EXPERTISE',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9CA3AF),
            ),
            GestureDetector(
              onTap: onEdit,
              child: const AppText(
                'Modifier',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F46E5),
              ),
            ),
          ],
        ),

        VGap.md(),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: skills.map(_buildSkillTag).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppText(
        label,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1F2937),
      ),
    );
  }
}

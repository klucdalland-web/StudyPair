import 'package:flutter/material.dart';

import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileStats extends StatelessWidget {
  final String rating;
  final String hours;
  final String mentees;

  const ProfileStats({
    super.key,
    required this.rating,
    required this.hours,
    required this.mentees,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(rating, 'Note globale', isRating: true),

          _buildDivider(),

          _buildStatItem(hours, 'Accompagnement'),

          _buildDivider(),

          _buildStatItem(mentees, 'Mentorés actifs'),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: const Color(0xFFF3F4F6));
  }

  Widget _buildStatItem(String value, String label, {bool isRating = false}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              value,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),

            if (isRating) ...[
              HGap.xs(),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 18,
              ),
            ],
          ],
        ),

        VGap.xs(),

        AppText(label, fontSize: 12, color: const Color(0xFF6B7280)),
      ],
    );
  }
}

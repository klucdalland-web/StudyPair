import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_card.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.rating,
    required this.hours,
    required this.mentees,
  });

  final String rating;
  final String hours;
  final String mentees;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 340;

          final items = [
            _StatItem(value: rating, label: 'Note globale', showStar: true),
            _StatItem(value: hours, label: compact ? 'Heures' : 'Accompagnement'),
            _StatItem(
              value: mentees,
              label: compact ? 'Mentorés' : 'Mentorés actifs',
            ),
          ];

          return Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: AppColors.divider,
                  ),
                Expanded(child: items[i]),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.showStar = false,
  });

  final String value;
  final String label;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: AppText(
                value,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showStar) ...[
              const HGap.xs(),
              const Icon(Icons.star_rounded, color: AppColors.star, size: 18),
            ],
          ],
        ),
        const VGap.xs(),
        AppText(
          label,
          fontSize: 12,
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

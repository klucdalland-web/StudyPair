import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

class Categoriesection extends StatelessWidget {
  const Categoriesection({super.key});

  static const _categories = <({IconData icon, Color color, String title})>[
    (
      icon: Icons.mail_outline_rounded,
      color: Color(0xFF605CF4),
      title: 'Demandes',
    ),
    (
      icon: Icons.school_outlined,
      color: Color(0xFFA11647),
      title: 'Étudiant',
    ),
    (
      icon: Icons.schedule_outlined,
      color: Color(0xFF4391FF),
      title: 'Créneaux',
    ),
    (
      icon: Icons.more_horiz_rounded,
      color: Color(0xFF7182F2),
      title: 'Plus',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 24),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return SizedBox(
              width: 72,
              child: Column(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      category.icon,
                      size: 28,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

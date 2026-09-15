import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../widgets/app_text.dart';
import '../../../../../widgets/gap.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const HGap.sm(),
        AppText(
          title,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        if (trailing != null) ...[const Spacer(), trailing!],
      ],
    );
  }
}

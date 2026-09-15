import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/gap.dart';

class PlanningPage extends StatelessWidget {
  const PlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTabScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Planning',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const VGap.sm(),
            const Text(
              'Organise tes sessions de révision.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/gap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    return AppTabScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final name = auth.user.value?.displayName ?? 'toi';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bonjour $name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const VGap.sm(),
              const Text(
                'Trouve un partenaire pour réviser.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/gap.dart';
import 'widgets/categorieSection.dart';
import 'widgets/demandesrecentes.dart';
import 'widgets/header.dart';
import 'widgets/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTabScaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(),
          const VGap.md(),
          // const Search(),
          const VGap.xl(),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                physics: AppPlatform.scrollPhysics,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Categoriesection(),
                    RecentRequestsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/dashboard/dashboard_controller.dart';

import '../../../../theme/app_colors.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  void _openMatchs() {
    Get.find<DashboardController>().changeTab(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          TextField(
            readOnly: true,
            onTap: _openMatchs,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 18, 56, 18),
              filled: true,
              fillColor: AppColors.surface,
              hintText: 'Rechercher une personne',
              hintStyle: TextStyle(
                color: AppColors.textTertiary.withValues(alpha: 0.9),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 26,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _openMatchs,
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.mic_outlined,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

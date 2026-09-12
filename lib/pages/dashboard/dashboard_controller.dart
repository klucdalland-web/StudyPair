import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_popup.dart';

/// Contrôle l'onglet actif du dashboard.
class DashboardController extends GetxController {
  static const planningTabIndex = 2;

  final currentIndex = 0.obs;

  void changeTab(int index) {
    if (index == planningTabIndex) {
      _showPlanningUnavailable();
      return;
    }
    currentIndex.value = index;
  }

  void _showPlanningUnavailable() {
    final context = Get.context;
    if (context == null) return;

    showAppPopup<void>(
      context: context,
      title: 'Bientôt disponible',
      message:
          'Le planning n’est pas encore disponible pour le moment. Reviens bientôt !',
      icon: Icons.event_busy_rounded,
      actions: [
        AppButton(
          label: 'Compris',
          onPressed: () => closeAppPopup(context),
        ),
      ],
    );
  }
}

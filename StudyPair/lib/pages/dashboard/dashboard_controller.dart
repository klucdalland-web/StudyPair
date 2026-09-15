import 'package:get/get.dart';

/// Contrôle l'onglet actif du dashboard.
class DashboardController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

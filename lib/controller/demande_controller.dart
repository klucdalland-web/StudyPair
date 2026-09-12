import 'package:get/get.dart';
import 'package:study_pair/models/demande_model.dart';

class DemandesController extends GetxController {
  // --- État d'écran ---
  final RxBool isLoading = false.obs;
  final Rxn<Map<String, dynamic>> user = Rxn<Map<String, dynamic>>();
  bool get hasUnreadNotifications => false;

  void onNotificationsTap() {}
  void onAvatarTap() {}

  // --- Onglets & listes ---
  final RxInt selectedTabIndex = 0.obs;

  final RxList<DemandeModel> demandesRecues = <DemandeModel>[].obs;

  final RxList<DemandeModel> demandesEnvoyees = <DemandeModel>[].obs;

  int get nombreDemandesActives =>
      demandesRecues.length + demandesEnvoyees.length;

  int get nombreDemandesRecues =>
      demandesRecues.where((d) => d.estEnAttente).length;

  int get nombreDemandesEnvoyees =>
      demandesEnvoyees.where((d) => d.estEnAttente).length;

  void selectTab(int index) => selectedTabIndex.value = index;

  void accepterDemande(String id) {
    final i = demandesRecues.indexWhere((d) => d.id == id);
    if (i == -1) return;
    demandesRecues[i] = demandesRecues[i].copyWith(
      status: DemandeStatus.accepted,
    );
    Get.snackbar('Demande acceptée', 'Votre créneau a été confirmé.');
  }

  void declinerDemande(String id) {
    final i = demandesRecues.indexWhere((d) => d.id == id);
    if (i == -1) return;
    demandesRecues[i] = demandesRecues[i].copyWith(
      status: DemandeStatus.declined,
    );
    Get.snackbar('Demande refusée', 'La demande a été refusée.');
  }
}

class DemandesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandesController>(() => DemandesController());
  }
}

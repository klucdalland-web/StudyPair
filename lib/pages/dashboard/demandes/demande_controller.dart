import 'package:get/get.dart';
import 'package:study_pair/models/demande_model.dart';

class DemandesController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  final RxList<DemandeModel> demandesRecues = <DemandeModel>[
    const DemandeModel(
      id: 'recue-thomas',
      senderId: 'thomas-d',
      receiverId: 'current-user',
      subject: 'Arbres et graphes',
      helpType: DemandeHelpType.mentorat,
      message:
          'Bonjour, je prépare le partiel d’arbres et graphes '
          'la semaine prochaine, j’aurais grand besoin d’aide '
          'sur les TD 4 et 5.',
      slotLabel: 'Jeudi 18h – 19h30',
      location: 'Visioconférence',
      mode: DemandeMode.visio,
    ),
    const DemandeModel(
      id: 'recue-ines',
      senderId: 'ines-b',
      receiverId: 'current-user',
      subject: 'Projet de deep learning',
      helpType: DemandeHelpType.binome,
      message:
          'Recherche binôme pour réviser le projet de deep learning '
          'ensemble et valider les architectures CNN.',
      slotLabel: 'Samedi matin',
      location: 'Campus Pierre et Marie Curie',
      mode: DemandeMode.presentiel,
    ),
  ].obs;

  final RxList<DemandeModel> demandesEnvoyees = <DemandeModel>[
    const DemandeModel(
      id: 'envoyee-camille',
      senderId: 'current-user',
      receiverId: 'camille-r',
      subject: 'Formalisme de Dirac',
      helpType: DemandeHelpType.mentorat,
      message:
          'Bonjour, je souhaiterais revoir les bases du formalisme '
          'de Dirac avant le prochain TD.',
      slotLabel: 'Mardi 17h',
      location: 'À définir',
      mode: DemandeMode.presentiel,
    ),
  ].obs;

  /// Nombre total de demandes actives.
  int get nombreDemandesActives =>
      demandesRecues.length + demandesEnvoyees.length;

  /// Demandes reçues en attente.
  int get nombreDemandesRecues =>
      demandesRecues.where((demande) => demande.estEnAttente).length;

  /// Demandes envoyées en attente.
  int get nombreDemandesEnvoyees =>
      demandesEnvoyees.where((demande) => demande.estEnAttente).length;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void accepterDemande(String id) {
    final index = demandesRecues.indexWhere((demande) => demande.id == id);

    if (index == -1) return;

    final demande = demandesRecues[index];

    demandesRecues[index] = demande.copyWith(status: DemandeStatus.accepted);

    Get.snackbar('Demande acceptée', 'Votre créneau a été confirmé.');
  }

  void declinerDemande(String id) {
    final index = demandesRecues.indexWhere((demande) => demande.id == id);

    if (index == -1) return;

    final demande = demandesRecues[index];

    demandesRecues[index] = demande.copyWith(status: DemandeStatus.declined);

    Get.snackbar('Demande refusée', 'La demande a été refusée.');
  }
}

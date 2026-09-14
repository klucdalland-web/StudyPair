import '../../../models/demande_model.dart';
final currentUserId = 'me';
List<DemandeModel> buildMockDemandes() {
  return [
    DemandeModel(
      id: "d1",
      senderId: 'thomas_d',
      receiverId: currentUserId,
      subject: 'Algorithmique et graphes',
      helpType: DemandeHelpType.mentorat,
      message:
          "Bonjour, je prépare le partiel d'arbres et graphes la semaine prochaine, j'aurais grand besoin d'aide sur les TD 4 et 5.",
      slotLabel: 'Jeudi 18h - 19h30',
      location: 'Visioconférence',
      mode: DemandeMode.visio,
      status: DemandeStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    DemandeModel(
      id: 'd2',
      senderId: 'ines_b',
      receiverId: currentUserId,
      subject: 'Machine learning et Python',
      helpType: DemandeHelpType.binome,
      message:
          'Recherche binôme pour réviser le projet de deep learning ensemble et valider les architectures CNN.',
      slotLabel: 'Samedi matin',
      location: 'Campus Pierre et Marie Curie',
      mode: DemandeMode.presentiel,
      status: DemandeStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

/// Infos d'affichage envoyeur — à remplacer par un vrai lookup profil/user.
class SenderDisplay {
  const SenderDisplay(this.name, this.initials, this.program);
  final String name;
  final String initials;
  final String program;
}

const mockSenders = {
  'thomas_d': SenderDisplay('Thomas D.', 'TD', 'L3 Informatique • Univ. Paris-Cité'),
  'ines_b': SenderDisplay('Inès B.', 'IB', 'M1 Data science • Sorbonne'),
};
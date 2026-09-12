import 'package:cloud_firestore/cloud_firestore.dart';

/// Petit sous-objet dénormalisé pour afficher la liste des conversations
/// (nom + photo de chaque participant) sans faire un fetch users/{uid}
/// par participant à chaque fois qu'on ouvre l'écran de conversations.
class ParticipantInfo {
  const ParticipantInfo({required this.displayName, this.photoUrl});

  final String displayName;
  final String? photoUrl;

  factory ParticipantInfo.fromMap(Map<String, dynamic> map) {
    return ParticipantInfo(
      displayName: map['displayName'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'photoUrl': photoUrl,
      };
}

class ConversationModel {
  const ConversationModel({
    required this.id,
    required this.participants,
    this.participantsInfo = const {},
    this.createdAt,
    this.lastMessage,
    this.lastMessageAt,
  });

  final String id;
  final List<String> participants; // remplace la table de jonction user_conversation
  final Map<String, ParticipantInfo> participantsInfo; // uid -> {displayName, photoUrl} dénormalisés
  final DateTime? createdAt;
  final String? lastMessage; // dénormalisation utile pour l'aperçu dans une liste de conversations
  final DateTime? lastMessageAt;

  factory ConversationModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final rawInfo = data['participantsInfo'] as Map<String, dynamic>? ?? {};
    return ConversationModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] as List? ?? const []),
      participantsInfo: rawInfo.map(
        (uid, value) => MapEntry(uid, ParticipantInfo.fromMap(Map<String, dynamic>.from(value as Map))),
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
        'participants': participants,
        'participantsInfo': participantsInfo.map((uid, info) => MapEntry(uid, info.toMap())),
        'lastMessage': lastMessage,
        'lastMessageAt':
            lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : FieldValue.serverTimestamp(),
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
      };

  String otherParticipant(String myUid) => participants.firstWhere((u) => u != myUid);

  ParticipantInfo? otherParticipantInfo(String myUid) => participantsInfo[otherParticipant(myUid)];
}

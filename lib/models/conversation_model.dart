import 'package:cloud_firestore/cloud_firestore.dart';

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
    this.title,
    this.createdAt,
    this.lastMessage,
    this.lastMessageAt,
  });

  final String id;
  final List<String> participants;
  final Map<String, ParticipantInfo> participantsInfo;
  final String? title;
  final DateTime? createdAt;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  bool get isGroup => participants.length > 2;

  factory ConversationModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final rawInfo = data['participantsInfo'] as Map<String, dynamic>? ?? {};
    return ConversationModel(
      id: doc.id,
      participants: List<String>.from(
        data['participants'] as List? ?? const [],
      ),
      participantsInfo: rawInfo.map(
        (uid, value) => MapEntry(
          uid,
          ParticipantInfo.fromMap(Map<String, dynamic>.from(value as Map)),
        ),
      ),
      title: data['title'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
    'participants': participants,
    'participantsInfo': participantsInfo.map(
      (uid, info) => MapEntry(uid, info.toMap()),
    ),
    if (title != null) 'title': title,
    'lastMessage': lastMessage,
    'lastMessageAt': lastMessageAt != null
        ? Timestamp.fromDate(lastMessageAt!)
        : FieldValue.serverTimestamp(),
    if (isNew) 'createdAt': FieldValue.serverTimestamp(),
  };

  String otherParticipant(String myUid) =>
      participants.firstWhere((u) => u != myUid);

  ParticipantInfo? otherParticipantInfo(String myUid) =>
      participantsInfo[otherParticipant(myUid)];
}

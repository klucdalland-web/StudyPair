import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  const ChatModel({
    required this.id,
    required this.participantIds,
    this.isValidated = false,
    this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
  });

  final String id;
  final List<String> participantIds;
  final bool isValidated;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  factory ChatModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ChatModel(
      id: doc.id,
      participantIds: List<String>.from(
        data['participantIds'] as List? ?? const [],
      ),
      isValidated: data['isValidated'] as bool? ?? false,
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
    'participantIds': participantIds,
    'isValidated': isValidated,
    'lastMessage': lastMessage,
    'lastMessageAt': lastMessageAt != null
        ? Timestamp.fromDate(lastMessageAt!)
        : null,
    'updatedAt': FieldValue.serverTimestamp(),
    if (isNew) 'createdAt': FieldValue.serverTimestamp(),
  };

  ChatModel copyWith({
    List<String>? participantIds,
    bool? isValidated,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id,
      participantIds: participantIds ?? this.participantIds,
      isValidated: isValidated ?? this.isValidated,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

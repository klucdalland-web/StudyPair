import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  const ChatModel({
    required this.id,
    required this.participantIds,
    this.isValidated = false,
    this.isGroup = false,
    this.title,
    this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
  });

  final String id;
  final List<String> participantIds;
  final bool isValidated;
  final bool isGroup;
  final String? title;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  factory ChatModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final participants = List<String>.from(
      data['participantIds'] as List? ?? const [],
    );
    return ChatModel(
      id: doc.id,
      participantIds: participants,
      isValidated: data['isValidated'] as bool? ?? false,
      isGroup: data['isGroup'] as bool? ?? participants.length > 2,
      title: data['title'] as String?,
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
    'participantIds': participantIds,
    'isValidated': isValidated,
    'isGroup': isGroup,
    'title': title,
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
    bool? isGroup,
    String? title,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id,
      participantIds: participantIds ?? this.participantIds,
      isValidated: isValidated ?? this.isValidated,
      isGroup: isGroup ?? this.isGroup,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

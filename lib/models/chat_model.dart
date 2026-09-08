import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  const ChatModel({
    required this.id,
    required this.participantIds,
    this.lastMessage,
  });

  final String id;
  final List<String> participantIds;
  final String? lastMessage;

  factory ChatModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ChatModel(
      id: doc.id,
      participantIds: List<String>.from(
        data['participantIds'] as List? ?? const [],
      ),
      lastMessage: data['lastMessage'] as String?,
    );
  }
}

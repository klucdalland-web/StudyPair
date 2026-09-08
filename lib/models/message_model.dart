import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String content;

  factory MessageModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    required String chatId,
  }) {
    final data = doc.data() ?? {};
    return MessageModel(
      id: doc.id,
      chatId: chatId,
      senderId: data['senderId'] as String? ?? '',
      content: data['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'content': content,
    'createdAt': FieldValue.serverTimestamp(),
  };
}

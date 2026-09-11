import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
     required this.sendAt,
    required this.isRead,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String content;
   final DateTime sendAt;
  final bool isRead;

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
      sendAt: (data['sendAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'content': content,
    'sendAt': FieldValue.serverTimestamp(),
    'isRead': false,
  };
  //Convertion depuis le jSON
  factory MessageModel.fromMap(Map<String, dynamic> map) {
  return MessageModel(
    id: map['id'],
    chatId: map['chatId'],
    senderId: map['senderId'],
    content: map['content'],
    sendAt: DateTime.now(),
    isRead: false,
  );
}
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    this.isReceived = false,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String conversationId;
  final String content;
  final String senderId;
  final String senderName; // dénormalisé depuis UserModel.displayName -> évite un fetch par message
  final String? senderPhotoUrl; // dénormalisé depuis UserModel.photoUrl
  final bool isReceived;
  final bool isRead;
  final DateTime? createdAt;

  factory MessageModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return MessageModel(
      id: doc.id,
      conversationId: data['conversationId'] as String? ?? '',
      content: data['content'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      senderPhotoUrl: data['senderPhotoUrl'] as String?,
      isReceived: data['isReceived'] as bool? ?? false,
      isRead: data['isRead'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
        'conversationId': conversationId,
        'content': content,
        'senderId': senderId,
        'senderName': senderName,
        'senderPhotoUrl': senderPhotoUrl,
        'isReceived': isReceived,
        'isRead': isRead,
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
      };

  MessageModel copyWith({bool? isReceived, bool? isRead}) {
    return MessageModel(
      id: id,
      conversationId: conversationId,
      content: content,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      isReceived: isReceived ?? this.isReceived,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

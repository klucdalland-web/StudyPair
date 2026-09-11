import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({
    required this.id,
    required this.participantIds,
    required this.isValidated,
  });

  final String id;
  final List<String> participantIds;
  bool isValidated;

  factory ChatModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ChatModel(
      id: doc.id,
      participantIds: List<String>.from(
        data['participantIds'] as List? ?? const [],
      ),
      isValidated: data['isValidated'] as bool? ?? false,
    );
  }
}

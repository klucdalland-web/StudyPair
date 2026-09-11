import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  const MatchModel({
    required this.id,
    required this.requesterId,
    required this.partnerId,
    required this.subject,
    this.status = 'pending',
  });

  final String id;
  final String requesterId;
  final String partnerId;
  final String subject;
  final String status;

  factory MatchModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return MatchModel(
      id: doc.id,
      requesterId: data['requesterId'] as String? ?? '',
      partnerId: data['partnerId'] as String? ?? '',
      subject: data['subject'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() => {
    'requesterId': requesterId,
    'partnerId': partnerId,
    'subject': subject,
    'status': status,
    'participantIds': [requesterId, partnerId],
    'createdAt': FieldValue.serverTimestamp(),
  };
}

import 'package:cloud_firestore/cloud_firestore.dart';

enum FriendRequestStatus { pending, accepted, refused, expired }

FriendRequestStatus _statusFromString(String? value) {
  switch (value) {
    case 'accepted':
      return FriendRequestStatus.accepted;
    case 'refused':
      return FriendRequestStatus.refused;
    case 'expired':
      return FriendRequestStatus.expired;
    default:
      return FriendRequestStatus.pending;
  }
}

/// Anciennement "Demande" dans le diagramme.
class FriendRequestModel {
  const FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.status = FriendRequestStatus.pending,
    this.message,
    this.expiresAt,
    this.createdAt,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final FriendRequestStatus status;
  final String? message;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  factory FriendRequestModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return FriendRequestModel(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      status: _statusFromString(data['status'] as String?),
      message: data['message'] as String?,
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
        'senderId': senderId,
        'receiverId': receiverId,
        'status': status.name,
        'message': message,
        'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
      };

  FriendRequestModel copyWith({FriendRequestStatus? status}) {
    return FriendRequestModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      status: status ?? this.status,
      message: message,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }
}

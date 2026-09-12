import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  const FriendModel({
    required this.id,
    required this.requestId,
    required this.userIds,
    this.acceptedAt,
  });

  final String id;
  final String requestId;
  final List<String> userIds; // [uidA, uidB] -> requêtable avec array-contains
  final DateTime? acceptedAt;

  factory FriendModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return FriendModel(
      id: doc.id,
      requestId: data['requestId'] as String? ?? '',
      userIds: List<String>.from(data['userIds'] as List? ?? const []),
      acceptedAt: (data['acceptedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
        'requestId': requestId,
        'userIds': userIds,
        if (isNew) 'acceptedAt': FieldValue.serverTimestamp(),
      };

  /// Retourne l'uid de l'autre ami à partir de mon propre uid.
  String otherUserId(String myUid) => userIds.firstWhere((u) => u != myUid);
}

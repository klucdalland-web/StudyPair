import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.typeId,
    required this.typeLabel,
    required this.content,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String typeId;
  final String typeLabel; // dénormalisé depuis NotificationTypeModel pour éviter un fetch séparé
  final String content;
  final bool isRead;
  final DateTime? createdAt;

  factory NotificationModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return NotificationModel(
      id: doc.id,
      typeId: data['typeId'] as String? ?? '',
      typeLabel: data['typeLabel'] as String? ?? '',
      content: data['content'] as String? ?? '',
      isRead: data['isRead'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
        'typeId': typeId,
        'typeLabel': typeLabel,
        'content': content,
        'isRead': isRead,
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
      };

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      typeId: typeId,
      typeLabel: typeLabel,
      content: content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

/// Optionnel : uniquement si la liste des types de notifications doit rester
/// gérable côté admin (collection top-level "notificationTypes").
/// Sinon, dénormalise juste "typeLabel" directement dans NotificationModel.
class NotificationTypeModel {
  const NotificationTypeModel({required this.id, required this.label});

  final String id;
  final String label;

  factory NotificationTypeModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return NotificationTypeModel(id: doc.id, label: data['label'] as String? ?? '');
  }

  Map<String, dynamic> toMap() => {'label': label};
}

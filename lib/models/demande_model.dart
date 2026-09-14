import 'package:cloud_firestore/cloud_firestore.dart';

/// Type d'aide demandée : tutorat encadré par un mentor, ou recherche de binôme.
enum DemandeHelpType {
  mentorat,
  binome;

  static DemandeHelpType fromValue(String? value) {
    return DemandeHelpType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => DemandeHelpType.mentorat,
    );
  }
}

/// Modalité du créneau proposé.
enum DemandeMode {
  visio,
  presentiel;

  static DemandeMode fromValue(String? value) {
    return DemandeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => DemandeMode.presentiel,
    );
  }
}

/// Statuts possibles d'une demande.
abstract class DemandeStatus {
  static const pending = 'pending';
  static const accepted = 'accepted';
  static const declined = 'declined';
  static const expired = 'expired';
}

/// Durée de validité par défaut d'une demande avant expiration automatique.
const Duration kDemandeValidityDuration = Duration(days: 5);

class DemandeModel {
  const DemandeModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.subject,
    required this.helpType,
    required this.message,
    required this.slotLabel,
    required this.location,
    this.mode = DemandeMode.presentiel,
    this.status = DemandeStatus.pending,
    this.chatId,
    this.friendId,
    this.createdAt,
    this.expiresAt,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final String subject;
  final DemandeHelpType helpType;
  final String message;
  final String slotLabel;
  final String location;
  final DemandeMode mode;
  final String status;
  /// Conversation créée à l'acceptation ([ChatModel]).
  final String? chatId;
  /// Lien d'amitié créé à l'acceptation ([FriendModel]).
  final String? friendId;
  final DateTime? createdAt;
  /// Date au-delà de laquelle une demande encore "pending" doit être
  /// considérée comme expirée. Calculée côté client à la création
  /// (createdAt + kDemandeValidityDuration) et stockée telle quelle.
  final DateTime? expiresAt;

  bool get estEnAttente => status == DemandeStatus.pending && !estExpiree;
  bool get estAcceptee => status == DemandeStatus.accepted;
  bool get estDeclinee => status == DemandeStatus.declined;

  /// Vrai si le statut stocké est encore "pending" mais que la date
  /// d'expiration est dépassée. Ne modifie rien en base à elle seule —
  /// c'est DemandeService qui se charge de persister le passage à "expired".
  bool get estExpiree {
    if (status != DemandeStatus.pending) return status == DemandeStatus.expired;
    final expiry = expiresAt;
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }

  bool estRecuePar(String userId) => receiverId == userId;
  bool estEnvoyeePar(String userId) => senderId == userId;

  String get tempsEcouleLabel {
    final date = createdAt;
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    return 'Il y a ${diff.inDays} jours';
  }

  /// Ex: "Expire dans 3 jours" / "Expire aujourd'hui" / "" si non pending.
  String get expirationLabel {
    if (status != DemandeStatus.pending) return '';
    final expiry = expiresAt;
    if (expiry == null) return '';
    final diff = expiry.difference(DateTime.now());
    if (diff.isNegative) return 'Expirée';
    if (diff.inDays >= 1) return 'Expire dans ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
    if (diff.inHours >= 1) return 'Expire dans ${diff.inHours}h';
    return 'Expire bientôt';
  }

  factory DemandeModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return DemandeModel(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      subject: data['subject'] as String? ?? '',
      helpType: DemandeHelpType.fromValue(data['helpType'] as String?),
      message: data['message'] as String? ?? '',
      slotLabel: data['slotLabel'] as String? ?? '',
      location: data['location'] as String? ?? '',
      mode: DemandeMode.fromValue(data['mode'] as String?),
      status: data['status'] as String? ?? DemandeStatus.pending,
      chatId: data['chatId'] as String?,
      friendId: data['friendId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) => {
    'senderId': senderId,
    'receiverId': receiverId,
    'participantIds': [senderId, receiverId],
    'subject': subject,
    'helpType': helpType.name,
    'message': message,
    'slotLabel': slotLabel,
    'location': location,
    'mode': mode.name,
    'status': status,
    'chatId': chatId,
    'friendId': friendId,
    'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    'updatedAt': FieldValue.serverTimestamp(),
    if (isNew) 'createdAt': FieldValue.serverTimestamp(),
  };

  DemandeModel copyWith({
    String? status,
    String? slotLabel,
    String? location,
    DemandeMode? mode,
    String? message,
    String? chatId,
    String? friendId,
    DateTime? expiresAt,
  }) {
    return DemandeModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      subject: subject,
      helpType: helpType,
      message: message ?? this.message,
      slotLabel: slotLabel ?? this.slotLabel,
      location: location ?? this.location,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      chatId: chatId ?? this.chatId,
      friendId: friendId ?? this.friendId,
      createdAt: createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
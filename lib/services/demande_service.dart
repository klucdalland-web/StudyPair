import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/demande_model.dart';
import 'package:study_pair/models/friend_model.dart';
import 'package:study_pair/models/notification_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/chats/services/chat_service.dart';

class DemandeService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _demandes =>
      _db.collection('demandes');

  CollectionReference<Map<String, dynamic>> get _friends =>
      _db.collection('friends');

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Non connecté');
    return uid;
  }

  Future<DemandeModel> create({
    required String receiverId,
    required String subject,
    required String message,
    DemandeHelpType helpType = DemandeHelpType.binome,
    DemandeMode mode = DemandeMode.visio,
    String slotLabel = 'Créneau à définir',
    String location = 'À définir',
  }) async {
    final senderId = _uid;
    if (receiverId == senderId) {
      throw Exception('Tu ne peux pas t\'envoyer une demande.');
    }

    if (await _areFriends(senderId, receiverId)) {
      throw Exception('Vous êtes déjà en binôme ensemble.');
    }

    if (await _hasPendingDemandeBetween(senderId, receiverId)) {
      throw Exception('Une demande est déjà en attente entre vous.');
    }

    final ref = _demandes.doc();
    final demande = DemandeModel(
      id: ref.id,
      senderId: senderId,
      receiverId: receiverId,
      subject: subject,
      helpType: helpType,
      message: message,
      slotLabel: slotLabel,
      location: location,
      mode: mode,
      // createdAt réel sera le serverTimestamp posé par toMap(isNew: true).
      // expiresAt est calculé côté client : une différence de quelques
      // secondes avec l'horloge serveur est négligeable sur une fenêtre de 5 jours.
      expiresAt: DateTime.now().add(kDemandeValidityDuration),
    );

    await ref.set(demande.toMap(isNew: true));
    await _notifyUser(
      userId: receiverId,
      typeId: 'demande_received',
      typeLabel: 'Nouvelle demande',
      content: 'Tu as reçu une demande ($subject).',
    );
    return demande;
  }

  /// Vrai si une demande "pending" et non expirée existe déjà entre les deux
  /// utilisateurs, dans un sens ou dans l'autre.
  Future<bool> _hasPendingDemandeBetween(String userA, String userB) async {
    final asSender = await _demandes
        .where('senderId', isEqualTo: userA)
        .where('receiverId', isEqualTo: userB)
        .where('status', isEqualTo: DemandeStatus.pending)
        .limit(1)
        .get();
    if (_hasNonExpired(asSender.docs)) return true;

    final asReceiver = await _demandes
        .where('senderId', isEqualTo: userB)
        .where('receiverId', isEqualTo: userA)
        .where('status', isEqualTo: DemandeStatus.pending)
        .limit(1)
        .get();
    return _hasNonExpired(asReceiver.docs);
  }

  bool _hasNonExpired(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    if (docs.isEmpty) return false;
    final demande = DemandeModel.fromDoc(docs.first);
    return !demande.estExpiree;
  }

  /// Vrai si les deux utilisateurs ont déjà un FriendModel les liant.
  Future<bool> _areFriends(String userA, String userB) async {
    final snapshot =
        await _friends.where('userIds', arrayContains: userA).get();
    return snapshot.docs.any((doc) {
      final userIds = List<String>.from(doc.data()['userIds'] as List? ?? const []);
      return userIds.contains(userB);
    });
  }

  Future<List<DemandeModel>> getDemandesRecues([String? userId]) async {
    final uid = userId ?? _uid;
    try {
      final snapshot =
          await _demandes.where('receiverId', isEqualTo: uid).get();
      final demandes = snapshot.docs.map(DemandeModel.fromDoc);
      return _sorted(await _expireIfNeeded(demandes));
    } catch (e, st) {
      _log('getDemandesRecues', e, st);
      rethrow;
    }
  }

  Future<List<DemandeModel>> getDemandesEnvoyees([String? userId]) async {
    final uid = userId ?? _uid;
    try {
      final snapshot =
          await _demandes.where('senderId', isEqualTo: uid).get();
      final demandes = snapshot.docs.map(DemandeModel.fromDoc);
      return _sorted(await _expireIfNeeded(demandes));
    } catch (e, st) {
      _log('getDemandesEnvoyees', e, st);
      rethrow;
    }
  }

  Future<List<DemandeModel>> getDemandesRecentes({int limit = 5}) async {
    final uid = _uid;
    final recues = await getDemandesRecues(uid);
    final pending = recues.where((d) => d.estEnAttente).toList();
    return pending.take(limit).toList();
  }

  Future<DemandeModel?> getById(String id) async {
    final doc = await _demandes.doc(id).get();
    if (!doc.exists) return null;
    final demande = DemandeModel.fromDoc(doc);
    final list = await _expireIfNeeded([demande]);
    return list.first;
  }

  /// Vérifie chaque demande "pending" dont expiresAt est dépassée et
  /// persiste le passage au statut "expired" en base. Retourne la liste
  /// avec les statuts à jour.
  Future<List<DemandeModel>> _expireIfNeeded(Iterable<DemandeModel> demandes) async {
    final result = <DemandeModel>[];
    for (final demande in demandes) {
      if (demande.status == DemandeStatus.pending && demande.estExpiree) {
        try {
          await _demandes.doc(demande.id).set(
            {
              'status': DemandeStatus.expired,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
          result.add(demande.copyWith(status: DemandeStatus.expired));
        } catch (e, st) {
          _log('_expireIfNeeded', e, st);
          result.add(demande); // on garde la version non expirée en cas d'échec d'écriture
        }
      } else {
        result.add(demande);
      }
    }
    return result;
  }

  Future<DemandeModel> accepter(String demandeId) async {
    final demande = await getById(demandeId);
    if (demande == null) throw Exception('Demande introuvable');
    if (demande.receiverId != _uid) {
      throw Exception('Tu ne peux pas accepter cette demande.');
    }
    if (!demande.estEnAttente) {
      throw Exception('Cette demande n\'est plus en attente.');
    }

    final chat = await Get.find<ChatService>().createChat(
      participantIds: [demande.senderId, demande.receiverId],
      isValidated: true,
    );

    final friendRef = _db.collection('friends').doc();
    final friend = FriendModel(
      id: friendRef.id,
      requestId: demande.id,
      userIds: [demande.senderId, demande.receiverId],
    );
    await friendRef.set(friend.toMap(isNew: true));

    final updated = demande.copyWith(
      status: DemandeStatus.accepted,
      chatId: chat.id,
      friendId: friend.id,
    );
    await _demandes.doc(demandeId).set(
      {
        'status': DemandeStatus.accepted,
        'chatId': chat.id,
        'friendId': friend.id,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await _notifyUser(
      userId: demande.senderId,
      typeId: 'demande_accepted',
      typeLabel: 'Demande acceptée',
      content: 'Ta demande « ${demande.subject} » a été acceptée.',
    );

    return updated;
  }

  Future<DemandeModel> decliner(String demandeId) async {
    final demande = await getById(demandeId);
    if (demande == null) throw Exception('Demande introuvable');
    if (demande.receiverId != _uid) {
      throw Exception('Tu ne peux pas refuser cette demande.');
    }

    final updated = demande.copyWith(status: DemandeStatus.declined);
    await _demandes.doc(demandeId).set(
      {
        'status': DemandeStatus.declined,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await _notifyUser(
      userId: demande.senderId,
      typeId: 'demande_declined',
      typeLabel: 'Demande refusée',
      content: 'Ta demande « ${demande.subject} » a été refusée.',
    );

    return updated;
  }

  Future<Map<String, UserModel>> loadUsersFor(List<DemandeModel> demandes) async {
    final ids = <String>{
      for (final d in demandes) ...[d.senderId, d.receiverId],
    };
    final result = <String, UserModel>{};
    for (final id in ids) {
      try {
        final doc = await _db.collection('users').doc(id).get();
        if (doc.exists) {
          result[id] = UserModel.fromDoc(doc);
        }
      } catch (_) {}
    }
    return result;
  }

  Future<void> _notifyUser({
    required String userId,
    required String typeId,
    required String typeLabel,
    required String content,
  }) async {
    try {
      final ref = _db.collection('users').doc(userId).collection('notifications').doc();
      final notif = NotificationModel(
        id: ref.id,
        typeId: typeId,
        typeLabel: typeLabel,
        content: content,
      );
      await ref.set(notif.toMap(isNew: true));
    } catch (e, st) {
      _log('_notifyUser', e, st);
    }
  }

  List<DemandeModel> _sorted(Iterable<DemandeModel> items) {
    final list = items.toList()
      ..sort((a, b) {
        final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return db.compareTo(da);
      });
    return list;
  }

  void _log(String method, Object e, StackTrace st) {
    developer.log(
      'Erreur DemandeService.$method',
      name: 'DemandeService',
      error: e,
      stackTrace: st,
    );
  }
}
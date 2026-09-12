import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DemandeService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _demandesCollection =>
      _db.collection('demandes');

  /// Crée une nouvelle demande.
  Future<String?> createDemande(
    String userId,
    String title,
    String description,
  ) async {
    try {
      final docRef = await _demandesCollection.add({
        'userId': userId,
        'title': title,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la création de la demande',
        name: 'DemandeService',
        error: e,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  /// Récupère toutes les demandes.
  Future<List<Map<String, dynamic>>> getDemandes() async {
    try {
      final snapshot = await _demandesCollection
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération des demandes',
        name: 'DemandeService',
        error: e,
        stackTrace: stackTrace,
      );

      return [];
    }
  }

  /// Récupère les demandes reçues par un utilisateur.
  Future<List<Map<String, dynamic>>> getDemandesRecues(String userId) async {
    try {
      final snapshot = await _demandesCollection
          .where('receiverId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération des demandes reçues',
        name: 'DemandeService',
        error: e,
        stackTrace: stackTrace,
      );

      return [];
    }
  }

  /// Récupère les demandes envoyées par un utilisateur.
  Future<List<Map<String, dynamic>>> getDemandesEnvoyees(String userId) async {
    try {
      final snapshot = await _demandesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la récupération des demandes envoyées',
        name: 'DemandeService',
        error: e,
        stackTrace: stackTrace,
      );

      return [];
    }
  }

  /// Met à jour une demande existante.
  Future<bool> updateDemande(
    String demandeId,
    String title,
    String description,
  ) async {
    try {
      await _demandesCollection.doc(demandeId).update({
        'title': title,
        'description': description,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la mise à jour de la demande',
        name: 'DemandeService',
        error: e,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  /// Supprime une demande.
  Future<bool> deleteDemande(String demandeId) async {
    try {
      await _demandesCollection.doc(demandeId).delete();

      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Erreur lors de la suppression de la demande',
        name: 'DemandeService',
        error: e,
        stackTrace: stackTrace,
      );

      return false;
    }
  }
}

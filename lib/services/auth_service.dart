import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  // serverClientId = client Web (type 3) — nécessaire pour obtenir l'idToken (surtout Android).
  final _google = GoogleSignIn(
    scopes: const ['email', 'profile'],
    serverClientId:
        '639858293131-3slpv6e2llg73bhe37ffpgjjhb1l0kqv.apps.googleusercontent.com',
  );

  AuthService to() => Get.find<AuthService>();
  final user = Rxn<UserModel>();

  bool get isLoggedIn => _auth.currentUser != null;
  String? get uid => _auth.currentUser?.uid;

  Future<AuthService> init() async {
    if (kDebugMode) {
      print('🔐 AuthService init…');
    }
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        if (kDebugMode) {
          print('👋 Auth: déconnecté');
        }
        user.value = null;
        return;
      }
      if (kDebugMode) {
        print('✅ Auth: session active → ${firebaseUser.email} (${firebaseUser.uid})');
      }
      // Ne crée jamais de profil ici — login ≠ register.
      // Si le doc n’existe pas encore (ex. mid signUp Google), on ne touche pas.
      final profile = await _getProfile(firebaseUser);
      if (profile != null) user.value = profile;
    });
    if (kDebugMode) {
      print('👀 Écoute authStateChanges activée');
    }
    return this;
  }

  Future<void> signIn(String email, String password) async {
    if (kDebugMode) {
      print('🔑 Login email… ($email)');
    }
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (kDebugMode) {
        print('✅ Login OK → ${cred.user?.uid}');
      }
      final profile = await _getProfile(cred.user!);
      if (profile == null) {
        await _auth.signOut();
        throw 'Aucun compte associé. Inscris-toi d\'abord.';
      }
      user.value = profile;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('❌ Login FAIL → ${e.code}');
      }
      throw _mapAuthError(e);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Une erreur est survenue. Réessaie.';
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email ou mot de passe incorrect.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'network-request-failed':
        return 'Problème de connexion réseau.';
      default:
        return 'Une erreur est survenue. Réessaie.';
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    bool isStudent = true,
  }) async {
    print('📝 Register… ($email)');
    try {
      final displayName = '${firstName.trim()} ${lastName.trim()}'.trim();
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user!.updateDisplayName(displayName);
      final profile = UserModel(
        id: cred.user!.uid,
        email: email.trim(),
        displayName: displayName,
        isOnline: true,
        isStudent: isStudent,
      );
      await _db.collection('users').doc(profile.id).set(profile.toMap(isNew: true));
      print('✅ Register OK + 📄 Firestore users/${profile.id}');
      user.value = profile;
    } catch (e) {
      print('❌ Register FAIL → $e');
      rethrow;
    }
  }

  /// Login Google : ne crée pas de compte. Le profil Firestore doit déjà exister.
  Future<void> signInWithGoogle() async {
    print('🟣 Google Sign-In (login)…');
    try {
      final firebaseUser = await _authenticateWithGoogle();
      final profile = await _getProfile(firebaseUser);
      if (profile == null) {
        await Future.wait([_auth.signOut(), _google.signOut()]);
        throw 'Aucun compte associé. Inscris-toi d\'abord.';
      }
      print('✅ Google login OK → ${firebaseUser.email}');
      user.value = profile;
    } catch (e) {
      print('❌ Google login FAIL → $e');
      rethrow;
    }
  }

  /// Register Google : crée le profil Firestore avec le choix Étudiant / non.
  Future<void> signUpWithGoogle({required bool isStudent}) async {
    print('🟣 Google Sign-Up (register)… isStudent=$isStudent');
    try {
      final firebaseUser = await _authenticateWithGoogle();
      final existing = await _getProfile(firebaseUser);
      if (existing != null) {
        print('📄 Compte Google déjà inscrit → login');
        user.value = existing;
        return;
      }
      final profile = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        isOnline: true,
        isStudent: isStudent,
      );
      await _db.collection('users').doc(profile.id).set(profile.toMap(isNew: true));
      print('✅ Google register OK + 📄 Firestore users/${profile.id}');
      user.value = profile;
    } catch (e) {
      print('❌ Google register FAIL → $e');
      rethrow;
    }
  }

  Future<User> _authenticateWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) {
      print('⚠️ Google annulé par l’utilisateur');
      throw 'Connexion Google annulée';
    }
    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) {
      print('❌ Google: idToken null');
      throw 'Impossible d\'obtenir le token Google. Vérifie la config OAuth.';
    }
    final cred = await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );
    return cred.user!;
  }

  Future<void> resetPassword(String email) {
    print('📧 Reset password → $email');
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    print('🚪 Sign out…');
    await Future.wait([_auth.signOut(), _google.signOut()]);
    user.value = null;
    print('👋 Sign out OK');
  }

  /// Charge le profil s’il existe — ne crée jamais de compte.
  Future<UserModel?> _getProfile(User firebaseUser) async {
    final ref = _db.collection('users').doc(firebaseUser.uid);
    try {
      final doc = await ref.get();
      if (!doc.exists) {
        print('📄 Firestore: pas de profil users/${firebaseUser.uid}');
        return null;
      }
      print('📄 Firestore: profil trouvé users/${firebaseUser.uid}');
      return UserModel.fromDoc(doc);
    } catch (e) {
      print('❌ Firestore FAIL (profil) → $e');
      rethrow;
    }
  }
}

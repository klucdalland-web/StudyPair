import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _google = GoogleSignIn();

  final user = Rxn<UserModel>();

  bool get isLoggedIn => _auth.currentUser != null;
  String? get uid => _auth.currentUser?.uid;

  Future<AuthService> init() async {
    print('🔐 AuthService init…');
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        print('👋 Auth: déconnecté');
        user.value = null;
        return;
      }
      print('✅ Auth: session active → ${firebaseUser.email} (${firebaseUser.uid})');
      user.value = await _getOrCreateProfile(firebaseUser);
    });
    print('👀 Écoute authStateChanges activée');
    return this;
  }

  Future<void> signIn(String email, String password) async {
    print('🔑 Login email… ($email)');
    try {
      
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('✅ Login OK → ${cred.user?.uid}');
      user.value = await _getOrCreateProfile(cred.user!);
    } catch (e) {
      print('❌ Login FAIL → $e');
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    print('📝 Register… ($email)');
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await cred.user!.updateDisplayName(name.trim());
      final profile = UserModel(
        id: cred.user!.uid,
        email: email.trim(),
        displayName: name.trim(),
      );
      await _db.collection('users').doc(profile.id).set(profile.toMap(isNew: true));
      print('✅ Register OK + 📄 Firestore users/${profile.id}');
      user.value = profile;
    } catch (e) {
      print('❌ Register FAIL → $e');
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    print('🟣 Google Sign-In…');
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        print('⚠️ Google annulé par l’utilisateur');
        throw Exception('Connexion Google annulée');
      }
      final googleAuth = await googleUser.authentication;
      final cred = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );
      print('✅ Google OK → ${cred.user?.email}');
      user.value = await _getOrCreateProfile(cred.user!);
    } catch (e) {
      print('❌ Google FAIL → $e');
      rethrow;
    }
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

  Future<UserModel> _getOrCreateProfile(User firebaseUser) async {
    final ref = _db.collection('users').doc(firebaseUser.uid);
    try {
      final doc = await ref.get();
      if (doc.exists) {
        print('📄 Firestore: profil trouvé users/${firebaseUser.uid}');
        return UserModel.fromDoc(doc);
      }
      final profile = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
      );
      await ref.set(profile.toMap(isNew: true));
      print('🆕 Firestore: profil créé users/${firebaseUser.uid}');
      return profile;
    } catch (e) {
      print('❌ Firestore FAIL (profil) → $e');
      rethrow;
    }
  }
}

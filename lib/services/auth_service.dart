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
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        user.value = null;
        return;
      }
      user.value = await _getOrCreateProfile(firebaseUser);
    });
    return this;
  }

  Future<void> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    user.value = await _getOrCreateProfile(cred.user!);
  }

  Future<void> signUp(String name, String email, String password) async {
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
    user.value = profile;
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) throw Exception('Connexion Google annulée');
    final googleAuth = await googleUser.authentication;
    final cred = await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );
    user.value = await _getOrCreateProfile(cred.user!);
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _google.signOut()]);
    user.value = null;
  }

  Future<UserModel> _getOrCreateProfile(User firebaseUser) async {
    final ref = _db.collection('users').doc(firebaseUser.uid);
    final doc = await ref.get();
    if (doc.exists) return UserModel.fromDoc(doc);
    final profile = UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
    );
    await ref.set(profile.toMap(isNew: true));
    return profile;
  }
}

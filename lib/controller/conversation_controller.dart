import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:study_pair/models/conversation_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/services/conversation_service.dart';

class ConversationsController extends GetxController {
  ConversationsController({ConversationService? service})
    : _service = service ?? Get.find<ConversationService>();

  final ConversationService _service;

  AuthService get _auth => Get.find<AuthService>();

  String get currentUserId => _auth.uid ?? '';

  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString query = ''.obs;

  StreamSubscription<List<ConversationModel>>? _sub;
  StreamSubscription<User?>? _authSub;

  @override
  void onInit() {
    super.onInit();

    // Re-lance le stream dès qu'un utilisateur est dispo
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) _listen();
    });

    _listen();
  }

  @override
  void onClose() {
    _sub?.cancel();
    _authSub?.cancel();
    super.onClose();
  }

  void _listen() {
    final uid = currentUserId;

    // Pas encore d'utilisateur connecté, on vide la liste et on met en loading
    if (uid.isEmpty) {
      conversations.clear();
      isLoading.value = true;
      return;
    }

    // Annule l'ancienne souscription avant d'en créer une nouvelle
    _sub?.cancel();
    isLoading.value = true;

    _sub = _service
        .watchConversations(uid)
        .listen(
          (list) {
            conversations.assignAll(list);
            isLoading.value = false;
          },
          onError: (Object e, StackTrace st) {
            print('❌ watchConversations error: $e\n$st');
            isLoading.value = false;
          },
        );
  }

  void updateQuery(String value) => query.value = value.trim().toLowerCase();

  Future<List<UserModel>> availableContacts() =>
      _service.availableContacts(currentUserId);

  Future<ConversationModel> createChat(String otherUserId) {
    return _service.createChat(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  Future<ConversationModel> createGroup({
    required List<String> memberIds,
    required String title,
  }) {
    return _service.createGroup(
      currentUserId: currentUserId,
      memberIds: memberIds,
      title: title,
    );
  }
}

class ConversationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationService>(() => ConversationService());
    Get.lazyPut<ConversationsController>(() => ConversationsController());
  }
}

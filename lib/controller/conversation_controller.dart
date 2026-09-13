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
  final usersById = <String, UserModel>{}.obs;

  StreamSubscription? _usersSub;
  String _watchedIds = '';

  void _syncUserWatchers() {
    final ids = <String>{};
    for (final c in conversations) {
      for (final id in c.participants) {
        if (id != currentUserId) ids.add(id);
      }
    }
    final key = (ids.toList()..sort()).join(',');
    if (key == _watchedIds) return;
    _watchedIds = key;

    _usersSub?.cancel();
    if (ids.isEmpty) {
      usersById.clear();
      return;
    }
    _usersSub = _service.watchUsersByIds(ids.toList()).listen((map) {
      usersById.assignAll(map);
    });
  }

  @override
  void onInit() {
    super.onInit();

    _authSub = FirebaseAuth.instance.authStateChanges().listen(
      (_) => _listen(),
    );

    _listen();
  }

  @override
  void onClose() {
    _sub?.cancel();
    _authSub?.cancel();
    _usersSub?.cancel();
    super.onClose();
  }

  void _listen() {
    final uid = currentUserId;

    _sub?.cancel();

    if (uid.isEmpty) {
      conversations.clear();
      usersById.clear();
      _watchedIds = '';
      isLoading.value = true;
      return;
    }

    isLoading.value = true;

    _sub = _service
        .watchConversations(uid)
        .listen(
          (list) {
            conversations.assignAll(list);
            isLoading.value = false;
            _syncUserWatchers();
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

  Stream<List<UserModel>> listFriends() => _service.watchFriends(currentUserId);

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

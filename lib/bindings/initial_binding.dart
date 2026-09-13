import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../pages/dashboard/chats/services/chat_service.dart';
import '../services/demande_service.dart';
import '../services/match_service.dart';
import '../services/user_service.dart';
import '../pages/dashboard/chats/services/mock_chat_service.dart';

/// Injection globale des services GetX.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _putIfAbsent(() => UserService());
    _putIfAbsent(() => DemandeService());
    _putIfAbsent(() => MatchService());
    _putIfAbsent(() => ChatService());
    Get.put(MockChatService());
  }

  /// À appeler dans `main` avant `runApp`.
  static Future<void> init() async {
    await Get.putAsync(() => AuthService().init(), permanent: true);
    InitialBinding().dependencies();
  }

  static void _putIfAbsent<T extends Object>(T Function() builder) {
    if (!Get.isRegistered<T>()) {
      Get.put<T>(builder(), permanent: true);
    }
  }
}

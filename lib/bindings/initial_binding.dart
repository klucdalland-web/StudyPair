import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/match_service.dart';
import '../services/user_service.dart';

/// Injection globale des services GetX.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _putIfAbsent(() => UserService());
    _putIfAbsent(() => MatchService());
    _putIfAbsent(() => ChatService());
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

import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../services/conversation_service.dart';
import '../services/demande_service.dart';
import '../services/match_service.dart';
import '../services/user_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    _putIfAbsent(() => UserService());
    _putIfAbsent(() => DemandeService());
    _putIfAbsent(() => MatchService());
    _putIfAbsent(() => ConversationService());
  }

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

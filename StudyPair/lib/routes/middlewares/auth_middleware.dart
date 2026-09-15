import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../app_routes.dart';

/// Bloque les pages réservées aux utilisateurs connectés.
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthService>() || !Get.find<AuthService>().isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}

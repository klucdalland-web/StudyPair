import 'package:get/get.dart';

import '../pages/auth/login/login_page.dart';
import '../pages/auth/register/register_page.dart';
import '../pages/dashboard/chat/chat_page.dart';
import '../pages/dashboard/dashboard_binding.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/pre_auth/splash/splash_page.dart';
import 'app_routes.dart';
import 'middlewares/auth_middleware.dart';
import 'middlewares/guest_middleware.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = <GetPage<dynamic>>[
    // Pre-auth
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
    ),

    // Auth
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      middlewares: [GuestMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      middlewares: [GuestMiddleware()],
      transition: Transition.rightToLeft,
    ),

    // Dashboard
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
      // middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatPage(),
      // middlewares: [AuthMiddleware()],
      transition: Transition.rightToLeft,
    ),
  ];
}

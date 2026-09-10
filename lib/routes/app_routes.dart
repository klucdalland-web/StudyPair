abstract class Routes {
  // --- Pre-auth ---
  static const splash = '/';

  // --- Auth ---
  static const login = '/login';
  static const register = '/register';

  // Register en deux étapes
  static const registerStepTwo = '/register/step-two';

  // --- Dashboard (après auth) ---
  static const dashboard = '/dashboard';
  static const chat = '/chat/:chatId';

  static String chatPath(String chatId) => '/chat/$chatId';
}

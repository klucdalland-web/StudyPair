abstract class Routes {
  // --- Pre-auth ---
  static const splash = '/';

  // --- Auth ---
  static const login = '/login';
  static const register = '/register';

  // --- Dashboard (après auth) ---
  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const chat = '/chat/:chatId';

  static String chatPath(String chatId) => '/chat/$chatId';
}

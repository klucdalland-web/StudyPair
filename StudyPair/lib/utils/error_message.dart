/// Helpers pour formater / nettoyer des messages d'erreur.
abstract class ErrorMessage {
  static String from(Object error) {
    final raw = error.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length);
    }
    if (raw.contains('network-request-failed')) {
      return 'Pas de connexion internet';
    }
    if (raw.contains('wrong-password') || raw.contains('invalid-credential')) {
      return 'Email ou mot de passe incorrect';
    }
    if (raw.contains('email-already-in-use')) {
      return 'Cet email est déjà utilisé';
    }
    if (raw.contains('user-not-found')) {
      return 'Aucun compte avec cet email';
    }
    if (raw.contains('weak-password')) {
      return 'Mot de passe trop faible';
    }
    return raw;
  }
}

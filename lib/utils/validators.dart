/// Validateurs de formulaires réutilisables.
abstract class Validators {
  static String? required(String? value, [String label = 'Ce champ']) {
    if (value == null || value.trim().isEmpty) {
      return '$label est requis';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, 'L\'email');
    if (requiredError != null) return requiredError;
    final email = value!.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!ok) return 'Email invalide';
    return null;
  }

  /// Email institutionnel : domaines `.edu`, `.fr` ou contenant `.univ`.
  static String? academicEmail(String? value) {
    final emailError = email(value);
    if (emailError != null) return emailError;
    final domain = value!.trim().toLowerCase().split('@').last;
    final isAcademic = domain.endsWith('.edu') ||
        domain.endsWith('.fr') ||
        domain.contains('.univ');
    if (!isAcademic) {
      return 'Utilisez un email académique (.edu, .fr ou .univ)';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final requiredError = required(value, 'Le mot de passe');
    if (requiredError != null) return requiredError;
    if (value!.length < minLength) {
      return 'Au moins $minLength caractères';
    }
    return null;
  }

  static String? minLength(String? value, int min, [String label = 'Ce champ']) {
    final requiredError = required(value, label);
    if (requiredError != null) return requiredError;
    if (value!.trim().length < min) {
      return '$label : au moins $min caractères';
    }
    return null;
  }

  static String? name(String? value, [String label = 'Ce champ']) {
    final requiredError = required(value, label);
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 2) {
      return 'Au moins 2 caractères';
    }
    return null;
  }
}

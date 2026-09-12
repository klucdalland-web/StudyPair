import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';

class ProfileController extends GetxController {
  final UserService _userService;
  final AuthService _authService;

  ProfileController({required this._userService, required this._authService});

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;

    try {
      user.value = await _userService.getMe();
    } catch (e) {
      final fallback = _authService.user.value;

      if (fallback != null) {
        user.value = fallback;
      } else {
        Get.snackbar('Erreur', 'Impossible de charger le profil.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? displayName,
    String? photoUrl,
    String? bio,
    String? university,
    String? level,
    List<String>? subjects,
    bool? isOnline,
    bool? isStudent,
  }) async {
    final current = user.value;
    if (current == null) {
      Get.snackbar('Erreur', 'Profil introuvable.');
      return false;
    }

    isSaving.value = true;
    try {
      final updated = current.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
        bio: bio,
        university: university,
        level: level,
        subjects: subjects,
        isOnline: isOnline,
        isStudent: isStudent,
      );
      await _userService.updateMe(updated);
      user.value = updated;
      Get.snackbar('Profil', 'Modifications enregistrées.');
      return true;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de mettre à jour le profil.');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.login);
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        userService: Get.find<UserService>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}

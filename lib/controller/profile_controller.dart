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

import 'package:get/get.dart';
import 'package:study_pair/models/demande_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/routes/app_routes.dart';
import 'package:study_pair/services/auth_service.dart';
import 'package:study_pair/services/conversation_service.dart';
import 'package:study_pair/services/demande_service.dart';

class DemandesController extends GetxController {
  DemandesController({
    DemandeService? demandeService,
    AuthService? authService,
    ConversationService? conversationsService,
  }) : _demandes = demandeService ?? Get.find<DemandeService>(),
       _auth = authService ?? Get.find<AuthService>(),
       _conversations = conversationsService ?? Get.find<ConversationService>();

  final DemandeService _demandes;
  final AuthService _auth;
  final ConversationService _conversations;

  final RxBool isLoading = true.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxList<DemandeModel> demandesRecues = <DemandeModel>[].obs;
  final RxList<DemandeModel> demandesEnvoyees = <DemandeModel>[].obs;
  final RxMap<String, UserModel> usersById = <String, UserModel>{}.obs;

  String? get currentUserId => _auth.uid;

  int get nombreDemandesActives =>
      demandesRecues.where((d) => d.estEnAttente).length +
      demandesEnvoyees.where((d) => d.estEnAttente).length;

  int get nombreDemandesRecues =>
      demandesRecues.where((d) => d.estEnAttente).length;

  int get nombreDemandesEnvoyees =>
      demandesEnvoyees.where((d) => d.estEnAttente).length;

  List<DemandeModel> get recentesEnAttente =>
      demandesRecues.where((d) => d.estEnAttente).take(5).toList();

  UserModel? userFor(DemandeModel demande) {
    final otherId = demande.estRecuePar(currentUserId ?? '')
        ? demande.senderId
        : demande.receiverId;
    return usersById[otherId];
  }

  @override
  void onInit() {
    super.onInit();
    loadDemandes();
  }

  void selectTab(int index) => selectedTabIndex.value = index;

  Future<void> loadDemandes() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _demandes.getDemandesRecues(),
        _demandes.getDemandesEnvoyees(),
      ]);
      demandesRecues.assignAll(results[0]);
      demandesEnvoyees.assignAll(results[1]);

      final users = await _demandes.loadUsersFor([
        ...demandesRecues,
        ...demandesEnvoyees,
      ]);
      usersById.assignAll(users);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les demandes.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> accepterDemande(String id) async {
    try {
      final updated = await _demandes.accepter(id);
      final i = demandesRecues.indexWhere((d) => d.id == id);
      if (i != -1) demandesRecues[i] = updated;

      if (updated.chatId == null) {
        Get.snackbar(
          'Demande acceptée',
          'Conversation créée. Tu peux discuter avec ton binôme.',
        );
        return;
      }

      final chat = await _conversations.getConversation(updated.chatId!);
      if (chat == null) {
        Get.snackbar('Erreur', 'Conversation introuvable.');
        return;
      }

      Get.snackbar(
        'Demande acceptée',
        'Conversation créée. Tu peux discuter avec ton binôme.',
      );

      await Get.toNamed(Routes.chatPath(chat.id), arguments: chat);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }

  Future<void> declinerDemande(String id) async {
    try {
      final updated = await _demandes.decliner(id);
      final i = demandesRecues.indexWhere((d) => d.id == id);
      if (i != -1) demandesRecues[i] = updated;
      Get.snackbar('Demande refusée', 'La demande a été refusée.');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    }
  }
}

class DemandesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DemandesController>(
      () => DemandesController(
        demandeService: Get.find<DemandeService>(),
        authService: Get.find<AuthService>(),
        conversationsService: Get.find<ConversationService>(),
      ),
    );
  }
}

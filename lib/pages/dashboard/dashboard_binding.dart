import 'package:get/get.dart';
import 'package:study_pair/controller/conversation_controller.dart';
import 'package:study_pair/services/conversation_service.dart';

import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut<ConversationService>(() => ConversationService());
    Get.lazyPut<ConversationsController>(() => ConversationsController());
  }
}

import 'dart:async';

import 'package:get/get.dart';
import 'package:study_pair/services/notification_service.dart';

import '../models/notification_model.dart';

class NotificationsController extends GetxController {
  NotificationsController(this._service);

  final NotificationsService _service;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<List<NotificationModel>>? _subscription;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _listen();
  }

  void _listen() {
    isLoading.value = true;
    _subscription = _service.watchNotifications().listen((items) {
      notifications.assignAll(items);
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);
  }

  Future<void> markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;
    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      notifications[index] = notification.copyWith(isRead: true);
    }
    await _service.markAsRead(notification.id);
  }

  Future<void> markAllAsRead() async {
    final unreadIds = notifications
        .where((n) => !n.isRead)
        .map((n) => n.id)
        .toList();
    if (unreadIds.isEmpty) return;

    for (var i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    notifications.refresh();

    await _service.markAllAsRead(unreadIds);
  }

  Future<void> refresh() async {
    await _subscription?.cancel();
    _listen();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

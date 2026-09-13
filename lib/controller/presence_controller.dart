import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../services/presence_service.dart';

class PresenceController extends GetxController with WidgetsBindingObserver {
  final AuthService _auth = Get.find<AuthService>();
  final _presence = PresenceService();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _set(true);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _set(false);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _set(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _set(false);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _set(bool online) {
    final uid = _auth.uid;
    if (uid != null && uid.isNotEmpty) {
      _presence.setOnline(uid, online);
    }
  }
}

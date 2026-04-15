import 'package:dody_store/core/services/Supabase_Service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/services/Firebase_Service.dart';

class DrawerControllerX extends GetxController {
  var currentRoute = ''.obs;
  var isDark = false.obs;

  var userImage = ''.obs;
  var userName = ''.obs;

  final authService = Get.find<FirebaseService>();
  final imageService = Get.find<SupabaseService>();
  @override
  void onInit() {
    super.onInit();
    currentRoute.value = Get.currentRoute;
    _loadUserData();
  }

  void _loadUserData() {
    final user = authService.currentUser;
    if (user == null) return;

    userName.value = user.displayName ?? 'User';
    userImage.value = user.photoURL ?? '';
  }

  void refreshUser() {
    _loadUserData();
  }

  void changePage(String route) {
    currentRoute.value = route;
    Get.toNamed(route);
  }

  void loadUserImage() {
    final user = authService.currentUser;
    if (user == null) return;

    final url = imageService.getPublicProfileImage(user.uid);
    userImage.value = url;
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}
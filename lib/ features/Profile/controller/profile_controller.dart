import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../../core/utils/routing/routes.dart';

class ProfileController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final photoUrl = ''.obs;

  final authService = Get.find<SupabaseService>();
  final imageService = Get.find<SupabaseService>();

  @override
  void onInit() {
    super.onInit();
    // _loadUserData();
  }

  // void _loadUserData() {
  //   final user = authService.currentUser;
  //   if (user == null) return;
  //
  //   name.value = user.displayName ?? 'No Name';
  //   email.value = user.email ?? '';
  //   photoUrl.value = user.photoURL ?? '';
  // }

  // Future<void> pickAndUploadImage(ImageSource source) async {
  //   final user = authService.currentUser;
  //   if (user == null) return;
  //
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: source);
  //   if (picked == null) return;
  //
  //   final file = File(picked.path);
  //
  //   final url = await imageService.uploadProfileImage(file, user.uid);
  //
  //   if (url != null) {
  //     photoUrl.value = url;
  //     await user.updatePhotoURL(url);
  //   }
  // }

  Future<void> logOut() async {
    await authService.logout();
    Get.offAllNamed(AppRoutes.logIn);
  }
}
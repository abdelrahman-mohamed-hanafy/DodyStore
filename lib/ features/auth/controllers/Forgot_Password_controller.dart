import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../UI/state/Auth_state.dart';
import '../../../core/services/Firebase_Service.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final emailError = Rx<String?>(null);
  final auth = Get.find<FirebaseService>();
  final state = Rx<AuthState>(Idle());

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> onPressed() async {
    emailError.value = null;

    validateEmail();
    if (emailError.value != null) return;

    try {
      state.value = Loading();
      await auth.sendPasswordResetEmail(emailController.text.trim());
      Get.snackbar(
        "Success",
        "If this email exists, a reset link has been sent",
      );
      Get.snackbar(
        'Warning',
        'Please check your spam message in your email for the reset link',
      );
      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      state.value = Idle();
    }
  }

  void validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = "Email can't be empty";
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Please enter a valid email";
    } else {
      emailError.value = null;
    }
  }
}

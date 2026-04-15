import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/internet_service.dart';
import '../../../core/utils/routing/routes.dart';
import '../UI/state/Auth_state.dart';
import '../../../core/services/Firebase_Service.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final Rx<bool> isPassword = true.obs;
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final nameError = Rx<String?>(null);
  final confirmPasswordError = Rx<String?>(null);
  final auth = Get.find<FirebaseService>();
  final internet = Get.find<InternetService>();
  var state = Rx<AuthState>(Idle());

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      if (nameController.text.isNotEmpty) {
        nameError.value = null;
      }
    });

    emailController.addListener(() {
      if (GetUtils.isEmail(emailController.text)) {
        emailError.value = null;
      }
    });

    passwordController.addListener(() {
      if (passwordController.text.length >= 6) {
        passwordError.value = null;
      }
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordController.text ==
          passwordController.text) {
        confirmPasswordError.value = null;
      }
    });

    ever(state, (value) {
      if (value is Success) {
        Get.offAllNamed(AppRoutes.logIn);
      } else if (value is Error) {
        Get.snackbar("Error", value.message);
      }
    });
  }

  void onPressed() async {
    _clearErrors();
    final isValid = check();
    if (!isValid) {
      return;
    }
    state.value = Loading();
    final hasInternet = await internet.hasInternet();
    if (!hasInternet) {
      state.value = Error("No internet connection");
      return;
    }
    try {
      final user = await auth.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      state.value = Success(user);
    } catch (e) {
      state.value = Error(_extractMessage(e));
    }
  }

  bool check() {
    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = "Enter your name";
      isValid = false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "Enter valid email";
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = "Enter your password";
      isValid = false;
    }

    else if (passwordController.text.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
      isValid = false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = "Passwords do not match";
      isValid = false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = "Confirm your password";
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = "Passwords do not match";
      isValid = false;
    }

    return isValid;
  }

  String _extractMessage(Object e) {
    if (e is Exception) {
      return e.toString().replaceFirst("Exception: ", "");
    }
    return "Something went wrong";
  }

  void _clearErrors() {
    nameError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
  }
}

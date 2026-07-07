import 'package:dody_store/core/services/Supabase_Service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/internet_service.dart';
import '../../../core/utils/routing/routes.dart';
import '../UI/state/Auth_State.dart';

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
  final auth = Get.find<SupabaseService>();
  final internet = Get.find<InternetService>();
  var state = Rx<AuthState>(Idle());

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

    // ever(state, (value) {
    //   if (value is Success) {
    //     FocusManager.instance.primaryFocus?.unfocus();
    //
    //     Future.microtask(() {
    //       Get.offAllNamed(AppRoutes.logIn);
    //     });
    //   }
    // });
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
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
      state.value = Success(user);
      Get.snackbar(
        'Success',
        'Account created successfully, please check your email for verification',
      );

      Get.offNamed(AppRoutes.logIn);
    } catch (e) {
      state.value = Error(_extractMessage(e));
      Get.snackbar('Error', _extractMessage(e));
    }
  }
  bool check() {
    return _validateName() &
    _validateEmail() &
    _validatePassword() &
    _validateConfirmPassword();
  }
  bool _validateName() {
    if (nameController.text.trim().isEmpty) {
      nameError.value = "Enter your name";
      return false;
    }
    return true;
  }

  bool _validateEmail() {
    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "Enter valid email";
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      passwordError.value = "Enter your password";
      return false;
    }

    if (password.length < 8) {
      passwordError.value =
      "Password must be at least 8 characters";
      return false;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      passwordError.value =
      "Password must contain an uppercase letter";
      return false;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      passwordError.value =
      "Password must contain a lowercase letter";
      return false;
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      passwordError.value =
      "Password must contain a number";
      return false;
    }

    if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
      passwordError.value =
      "Password must contain a special character \n(@, \$, !, %, *, ?, &)";
      return false;
    }

    return true;
  }

  bool _validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value =
      "Confirm your password";
      return false;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      confirmPasswordError.value =
      "Passwords do not match";
      return false;
    }

    return true;
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
}

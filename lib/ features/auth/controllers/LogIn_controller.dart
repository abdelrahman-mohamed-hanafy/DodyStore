import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/internet_service.dart';
import '../UI/state/Auth_state.dart';
import '../../../core/services/Firebase_Service.dart';

class LogInController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final Rx<bool> isPassword = true.obs;
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final auth = Get.find<FirebaseService>();
  final internet = Get.find<InternetService>();
  final state = Rx<AuthState>(Idle());

  @override
  void onInit() {
    ever(state, (value) {
      if (value is Success) {
        Get.offAllNamed(AppRoutes.mainPage);
      } else if (value is Error) {
        Get.snackbar("Error", value.message);
      } else if (value is Cancelled) {
        Get.snackbar("Cancelled", "Login cancelled");
      }
    });
    emailController.addListener(() {
      if (GetUtils.isEmail(emailController.text)) {
        emailError.value = null;
      }
    });

    passwordController.addListener(() {
      passwordError.value = null;
    });
    super.onInit();
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  Future<void> onPressed() async {
      final isValid = check();
      if (!isValid) return;
    final hasInternet = await internet.hasInternet();
    if (!hasInternet) {
      state.value = Error("No internet connection");
      return;
    }
      state.value = Loading();
      try {
      final user = await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      state.value = Success(user);

    } catch (e) {
      final message = _extractMessage(e);

      if (message.contains("No user found")) {
        state.value = Error("No account found with this email");
      } else if (message.contains("Wrong password")) {
        state.value = Error("Incorrect password");
      } else {
        state.value = Error(message);
      }
    }
  }

  // check
  bool check() {
    bool isValid = true;
    if (emailController.text.trim().isEmpty) {
      emailError.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "Please enter a valid email";
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    }
    return isValid;
  }
  // SignIn with Google
  Future<void> loginWithGoogle() async {
   state.value = Loading();
   try{
     final user = await auth.signInWithGoogle();
     if(user != null){
       state.value = Success(user);
     }else{
       state.value = Cancelled();
     }
   }catch (e) {
     final message = _extractMessage(e);
     if (message.contains("already registered")) {
       state.value = Error(
         "This email is already registered. Please login using the original method.",
       );
     } else {
       state.value = Error(message);
       print("Google Sign-In Error: $message");
     }
   }
  }
  // SignIn with Facebook
  Future<void> logInWithFacebook() async {
    state.value = Loading();
    try {
      final user = await auth.signInWithFacebook();
      if (user != null) {
        state.value = Success(user);
      } else {
        state.value = Cancelled();
      }
    } catch (e) {
      final message = _extractMessage(e);
      if (message.contains("already registered")) {
        state.value = Error(
          "This email is already registered. Please login using the original method.",
        );
      } else {
        state.value = Error(message);
      }
    }
  }
  String _extractMessage(Object e) {
    if (e is Exception) {
      return e.toString().replaceFirst("Exception: ", "");
    }
    return "Something went wrong";
  }

}
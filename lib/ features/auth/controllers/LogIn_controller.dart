import 'dart:async';

import 'package:dody_store/core/services/Supabase_Service.dart';
import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../../core/services/internet_service.dart';
import '../UI/state/Auth_State.dart';

class LogInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final isPassword = true.obs;

  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);

  final auth = Get.find<SupabaseService>();
  final internet = Get.find<InternetService>();

  final state = Rx<AuthState>(Idle());

  late Worker _worker;
  late final StreamSubscription _authSubscription;

  @override
  void onInit() {
    super.onInit();

    _worker = ever<AuthState>(state, (value) {
      if (value is Success) {
        Get.offAllNamed(AppRoutes.mainPage);
      } else if (value is Error) {
        Get.snackbar(
          "Error",
          value.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (value is Cancelled) {
        Get.snackbar(
          "Cancelled",
          "Login cancelled",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });

    emailController.addListener(() {
      if (GetUtils.isEmail(emailController.text.trim())) {
        emailError.value = null;
      }
    });

    passwordController.addListener(() {
      if (passwordController.text.trim().length >= 6) {
        passwordError.value = null;
      }
    });

    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
          switch (data.event) {
            case AuthChangeEvent.signedIn:
              if (data.session != null) {
                state.value = Success(data.session!.user);
              }
              break;

            case AuthChangeEvent.signedOut:
              state.value = Idle();
              break;


            default:
              break;
          }
        });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    _worker.dispose();
    _authSubscription.cancel();

    super.onClose();
  }

  Future<void> onPressed() async {
    if (state.value is Loading) return;

    if (!check()) return;

    final hasInternet = await internet.hasInternet();

    if (!hasInternet) {
      state.value = Error("No internet connection");
      return;
    }

    state.value = Loading();

    try {
      await auth.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      state.value = Error(_extractMessage(e));
    }
  }

  Future<void> loginWithGoogle() async {
    if (state.value is Loading) return;

    final hasInternet = await internet.hasInternet();

    if (!hasInternet) {
      state.value = Error("No internet connection");
      return;
    }

    state.value = Loading();

    try {
      await auth.signInWithGoogle();

    } catch (e) {
      final message = _extractMessage(e);

      if (message.toLowerCase().contains("cancel")) {
        state.value = Cancelled();
      } else {
        state.value = Error(message);
      }
    }
  }

  Future<void> logInWithFacebook() async {
    if (state.value is Loading) return;

    final hasInternet = await internet.hasInternet();

    if (!hasInternet) {
      state.value = Error("No internet connection");
      return;
    }

    state.value = Loading();
      await auth.signInWithFacebook();
      // اضريت لهذا لان الsignInWithOAuth مبيرميش cancel Exception
    Future.delayed(const Duration(seconds: 1), () {
      if (state.value is Loading &&
          Supabase.instance.client.auth.currentSession == null) {
        state.value = Cancelled();
      }
    });
  }

  bool check() {
    bool valid = true;

    final email = emailController.text.trim();
    final password = passwordController.text;

    emailError.value = null;
    passwordError.value = null;

    if (email.isEmpty) {
      emailError.value = "Email is required";
      valid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Please enter a valid email";
      valid = false;
    }

    if (password.isEmpty) {
      passwordError.value = "Password is required";
      valid = false;
    } else if (password.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
      valid = false;
    }
    return valid;
  }

  String _extractMessage(Object e) {
    if (e is AuthException) {
      return auth.mapAuthError(e);
    }

    if (e is Exception) {
      return e.toString().replaceFirst("Exception: ", "");
    }

    return "Something went wrong";
  }
}
import 'package:dody_store/core/theme/app_colors.dart';
import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_buttton.dart';
import '../../controllers/LogIn_controller.dart';
import '../state/Auth_state.dart';
import '../widgets/SocialButton.dart';
import '../widgets/TextField_wid.dart';
import '../../../../core/theme/AppBackground.dart';

class LogInPage extends GetView<LogInController> {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return AppBackground(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 65),

                        /// 🔥 LOGO
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            height: 100,
                            width: 100,
                            child: Center(
                              child: Image.asset(
                                'assets/images/Logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 🔥 TITLE
                        const Center(
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        const Center(
                          child: Text(
                            'Sign in to your account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔥 FORM CARD
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// EMAIL
                                const Text(
                                  'Email',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                TextFieldWid(
                                  errorText: controller.emailError.value,
                                  hintText: 'Enter Your Email',
                                  prefixIcon: const Icon(Icons.email),
                                  controller: controller.emailController,
                                  isPassword: false,
                                  focusNode: controller.emailFocusNode,
                                  nextFocusNode:
                                  controller.passwordFocusNode,
                                  isDone: false,
                                ),

                                const SizedBox(height: 12),

                                /// PASSWORD
                                const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                TextFieldWid(
                                  errorText: controller.passwordError.value,
                                  hintText: 'Enter Your Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: Obx(
                                        () => IconButton(
                                      onPressed: () {
                                        controller.isPassword.value =
                                        !controller.isPassword.value;
                                      },
                                      icon: Icon(
                                        controller.isPassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,

                                      ),
                                    ),
                                  ),
                                  controller: controller.passwordController,
                                  isPassword:
                                  controller.isPassword.value,
                                  focusNode:
                                  controller.passwordFocusNode,
                                  isDone: true,
                                ),

                                const SizedBox(height: 6),

                                /// FORGOT PASSWORD
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Get.toNamed(
                                          AppRoutes.forgotPassword);
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// LOGIN BUTTON
                                Center(
                                  child: CustomButton(
                                    text: 'Log In',
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      controller.onPressed();
                                    },
                                  ),
                                ),

                                const SizedBox(height: 12),

                                /// OR
                                const Center(
                                  child: Text(
                                    'OR Continue with',
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// SOCIAL
                                Row(
                                  children: [
                                    Expanded(
                                      child: SocialButton(
                                        onPressed: controller
                                            .logInWithFacebook,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.facebookF,
                                          color: Colors.blue,
                                        ),
                                        text: 'Facebook',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: SocialButton(
                                        onPressed:
                                        controller.loginWithGoogle,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.google,
                                          color: Colors.red,
                                        ),
                                        text: 'Google',
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                /// SIGN UP
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppRoutes.signUp);
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 🔥 LOADING
            if (state is Loading)
              AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
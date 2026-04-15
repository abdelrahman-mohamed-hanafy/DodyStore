import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/routing/routes.dart';
import '../../../../core/widgets/custom_buttton.dart';
import '../../controllers/SignUp_controller.dart';
import '../state/Auth_state.dart';
import '../../../../core/theme/AppBackground.dart';
import '../widgets/TextField_wid.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

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
                      mainAxisAlignment: MainAxisAlignment.center,
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

                        const SizedBox(height: 2.0),

                        const Center(
                          child: Text(
                            'Sign up to your account',
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

                                /// NAME
                                const Text(
                                  'Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                TextFieldWid(
                                  hintText: 'Enter Your Name',
                                  prefixIcon: const Icon(Icons.person),
                                  controller: controller.nameController,
                                  errorText: controller.nameError.value,
                                  isPassword: false,
                                  nextFocusNode: controller.emailFocusNode,
                                  focusNode: controller.nameFocusNode,
                                  isDone: false,
                                ),

                                const SizedBox(height: 10),

                                /// EMAIL
                                const Text(
                                  'Email',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                TextFieldWid(
                                  hintText: 'Enter Your Email',
                                  prefixIcon: const Icon(Icons.email,),
                                  controller: controller.emailController,
                                  errorText: controller.emailError.value,
                                  isPassword: false,
                                  nextFocusNode: controller.passwordFocusNode,
                                  focusNode: controller.emailFocusNode,
                                  isDone: false,
                                ),

                                const SizedBox(height: 10),

                                /// PASSWORD
                                const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                TextFieldWid(
                                  hintText: 'Enter Your Password',
                                  errorText: controller.passwordError.value,
                                  prefixIcon: const Icon(Icons.lock, ),
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
                                  isPassword: controller.isPassword.value,
                                  nextFocusNode: controller.confirmPasswordFocusNode,
                                  focusNode: controller.passwordFocusNode,
                                  isDone: false,
                                ),

                                const SizedBox(height: 10),

                                /// CONFIRM PASSWORD
                                const Text(
                                  'Confirm Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                TextFieldWid(
                                  hintText: 'Confirm Your Password',
                                  errorText: controller.confirmPasswordError.value,
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

                                  controller: controller.confirmPasswordController,
                                  isPassword: controller.isPassword.value,
                                  focusNode: controller.confirmPasswordFocusNode,
                                  isDone: true,
                                ),
                                const SizedBox(height: 20),

                                /// BUTTON
                                Center(
                                  child: CustomButton(
                                    text: 'Sign UP',
                                    onPressed: controller.onPressed,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'I Have An Account',
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppRoutes.logIn);
                                      },
                                      child: const Text(
                                        'Log IN',
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
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    });
  }
}

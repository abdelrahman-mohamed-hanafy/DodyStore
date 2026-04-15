import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_buttton.dart';
import '../../controllers/Forgot_Password_controller.dart';
import '../state/Auth_state.dart';
import '../widgets/TextField_wid.dart';
import '../../../../core/theme/AppBackground.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppBackground(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        /// 🔙 BACK
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Row(
                            children: const [
                              SizedBox(width: 8),
                              Icon(Icons.arrow_back,
                                  color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Back to Login',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 65),

                        /// 🔥 LOGO
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'assets/images/Logo.png',
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 🔥 TITLE
                        const Center(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Center(
                          child: Text(
                            'Enter your email to reset your password',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔥 CARD
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                            Colors.white.withOpacity(0.08),
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white24),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email Address',
                                  style: TextStyle(
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 6),

                                TextFieldWid(
                                  errorText:
                                  controller.emailError.value,
                                  hintText:
                                  'Enter Your Email',
                                  prefixIcon: const Icon(
                                      Icons.email_outlined),
                                  controller:
                                  controller.emailController,
                                  isPassword: false,
                                  isDone: true,
                                ),

                                const SizedBox(height: 20),

                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    text: 'Send Reset Link',
                                    onPressed:
                                    controller.onPressed,
                                  ),
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
            if (controller.state.value is Loading)
              AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                      child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      );
    });
  }
}
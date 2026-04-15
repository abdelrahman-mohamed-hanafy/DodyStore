import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main/Controller/main_controller.dart';
import '../../controller/profile_controller.dart';
import '../widgets/ProfileHeader.dart';
import '../widgets/ProfileSection.dart';
import '../widgets/Profile_Item.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final mainController = Get.find<MainController>();
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 100,
                ),
                child: SingleChildScrollView(
                    child:SafeArea(
                      child: Column(
                        children: [
                           ProfileHeader(),
                          const SizedBox(height: 20),

                          ProfileSection(
                            title: 'Account',
                            children: [
                              profileItem(title: 'Edit Profile', prefixIcon: Icons.person, onTap: () {}),
                              profileItem(title: 'Address', prefixIcon: Icons.location_on, onTap: () {}),
                              profileItem(title: 'Payment Methods', prefixIcon: Icons.credit_card, onTap: () {}),
                              profileItem(title: 'Orders Status', prefixIcon: Icons.local_shipping, onTap: () {}),
                            ],
                          ),

                          ProfileSection(
                            title: 'Settings',
                            children: [
                              profileItem(title: 'Language', prefixIcon: Icons.translate, text: 'English', onTap: () {}),
                              profileItem(title: 'Dark Mode', prefixIcon: Icons.dark_mode, onTap: () {},suffixIcon: Icons.toggle_off_outlined,size: 40,),
                            ],
                          ),

                          ProfileSection(
                            title: 'Support',
                            children: [
                              profileItem(title: 'Help Center', prefixIcon: Icons.help_outline, onTap: () {}),
                              profileItem(title: 'Contact Us', prefixIcon: Icons.headset_mic, onTap: () {}),
                              Container(
                                width: double.infinity,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF7CA3),
                                      Color(0xFF8F7CFF),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

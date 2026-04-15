import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
   ProfileHeader({super.key});
  final controller = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() => CircleAvatar(
              radius: 80,
              backgroundColor: Colors.black26,
              backgroundImage: controller.photoUrl.value.isNotEmpty
                  ? NetworkImage(controller.photoUrl.value)
                  : null,
              child: controller.photoUrl.value.isEmpty
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            )),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child:IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Change Photo",
                      middleText: "Choose source",
                      textConfirm: "Camera",
                      textCancel: "Gallery",
                      onConfirm: () {
                        Get.back();
                        controller.pickAndUploadImage(ImageSource.camera);
                      },
                      onCancel: () {
                        controller.pickAndUploadImage(ImageSource.gallery);
                      },
                    );
                  },
              ),)
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          controller.name.value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
         Text(
          controller.email.value,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
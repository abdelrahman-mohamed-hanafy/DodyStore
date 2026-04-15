import 'package:flutter/material.dart';

/// 🎯 Category Item Widget
class CategoryItem_Widget extends StatelessWidget {
  final String title;
  final String image;

  const CategoryItem_Widget({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF8F7CFF), // 🔥 Purple Glow
                Color(0xFFFF7CA3), // 🔥 Pink Glow
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFF1A1A2E), // 🔥 Dark Glass Base
            backgroundImage: NetworkImage(image),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
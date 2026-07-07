import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.count = 0,
    this.iconColor = Colors.white,
    this.badgeColor = const Color(0xffFF5CA8),
    this.size = 26,
  });

  final IconData icon;
  final VoidCallback onTap;
  final int count;
  final Color iconColor;
  final Color badgeColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: onTap,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Center(
                child: Icon(
                  icon,
                  size: size,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),

        if (count > 0)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xff1A1A2E),
                  width: 1.5,
                ),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
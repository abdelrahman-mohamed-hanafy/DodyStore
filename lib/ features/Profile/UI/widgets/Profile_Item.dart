import 'package:flutter/material.dart';

class profileItem extends StatelessWidget {
  final String title;
  final String? text;
  final double? size;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback onTap;
  profileItem({super.key, required this.title, required this.prefixIcon, required this.onTap,  this.suffixIcon, this.text, this.size});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(prefixIcon, color: Colors.white70),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(text??'',style: TextStyle(color: Colors.white),),
              SizedBox(width: 8.0),
              Icon(suffixIcon ?? Icons.arrow_forward_ios,size: size??16, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

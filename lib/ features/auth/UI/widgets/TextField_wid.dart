import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldWid extends StatelessWidget {
   const TextFieldWid({super.key, required this.hintText, required this.prefixIcon, this.suffixIcon,required this.controller, required this.isPassword, this.errorText, this.nextFocusNode, this.focusNode, required this.isDone});
   final String hintText;
   final Icon prefixIcon;
   final Widget? suffixIcon;
   final bool isPassword;
   final TextEditingController controller;
   final String? errorText;
   final FocusNode? focusNode;
   final bool isDone;

   final FocusNode? nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      focusNode:  focusNode,
        textInputAction:isDone?TextInputAction.done :TextInputAction.next,
        onEditingComplete: () {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.purple,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
      ),
      )
    );
  }
}

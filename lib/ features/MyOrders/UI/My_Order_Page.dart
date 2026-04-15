import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:flutter/material.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text(
          "My Orders Page",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    ));
  }
}

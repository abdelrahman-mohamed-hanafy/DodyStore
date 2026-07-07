import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/CustomDrawer.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(child: Scaffold(
      backgroundColor: Colors.transparent,
      drawer: CustomDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white,size: 30),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

    ));
  }
}

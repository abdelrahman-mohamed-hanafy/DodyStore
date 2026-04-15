import 'package:dody_store/core/services/Supabase_Service.dart';
import 'package:dody_store/core/theme/app_colors.dart';
import 'package:dody_store/core/utils/routing/router.dart';
import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/Firebase_Service.dart';
import 'core/config/firebase_options.dart';
import 'core/services/hive_service.dart';
import 'core/services/internet_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"]!,
      anonKey: dotenv.env["SUOABASE_KEY"]!);
  final hive = HiveService();
  await hive.init();
  runApp( MyApp(hive: hive,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.hive});
  final HiveService hive;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      initialBinding: BindingsBuilder((){
        Get.put(hive, permanent: true);
        Get.put(FirebaseService(), permanent: true);
        Get.put(SupabaseService(),permanent: true);
        Get.put(InternetService(), permanent: true);
      }),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}

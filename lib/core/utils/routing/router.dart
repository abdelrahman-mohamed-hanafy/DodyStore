import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:get/get.dart';
import '../../../ features/Cart/UI/Pages/cart_page.dart';
import '../../../ features/Favourites/UI/pages/favourite_page.dart';
import '../../../ features/Notification/UI/pages/notification_page.dart';
import '../../../ features/Products/UI/pages/bags_page.dart';
import '../../../ features/Products/UI/pages/hoodies_page.dart';
import '../../../ features/Products/UI/pages/men_accessories.dart';
import '../../../ features/Products/UI/pages/product_details.dart';
import '../../../ features/Products/UI/pages/products_page.dart';
import '../../../ features/Products/UI/pages/womenAccessories_page.dart';
import '../../../ features/Products/controller/ProductDetailsController.dart';
import '../../../ features/Profile/UI/Pages/profile_page.dart';
import '../../../ features/Search/UI/Pages/search_page.dart';
import '../../../ features/auth/UI/pages/Forgot_Password_page.dart';
import '../../../ features/auth/UI/pages/LogIn_Page.dart';
import '../../../ features/auth/UI/pages/SignUp_page.dart';
import '../../../ features/auth/controllers/Forgot_Password_controller.dart';
import '../../../ features/auth/controllers/LogIn_controller.dart';
import '../../../ features/auth/controllers/SignUp_controller.dart';
import '../../../ features/home/UI/pages/Home_Page.dart';
import '../../../ features/main/Binding/MainBinding.dart';
import '../../../ features/main/UI/Pages/main_page.dart';
import '../../../ features/onBoarding/UI/pages/onBoarding_page.dart';
import '../../../ features/onBoarding/controller/onBoarding_controller.dart';
import '../../../ features/splash/UI/splash_page.dart';
import '../../../ features/splash/controller/splash_controller.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpPage(),
      binding: BindingsBuilder((){
        Get.lazyPut(() => SignUpController());
      }),
    ),
    GetPage(
      name: AppRoutes.logIn,
      page: () => LogInPage(),
      binding: BindingsBuilder((){
        Get.lazyPut(() => LogInController());
      })
    ),
    GetPage(name: AppRoutes.home, page: () => HomePage(),),
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: BindingsBuilder((){
        Get.lazyPut(() => SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnBoardingPage(),
      binding: BindingsBuilder((){
        Get.lazyPut(() => OnBoardingController());
      })
    ),
    GetPage(
        name: AppRoutes.forgotPassword,
        page: ()=>ForgotPasswordPage(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => ForgotPasswordController());
        }),
    ),
    GetPage(name: AppRoutes.mainPage, page:()=> MainPage(),
    binding: MainBinding()),
    GetPage(name: AppRoutes.search, page:()=> SearchPage(),),
    GetPage(name: AppRoutes.profile, page:()=> ProfilePage(),),
    GetPage(name: AppRoutes.cart, page:()=> CartPage(),),
    GetPage(name: AppRoutes.productPage, page:()=> ProductsPage(),),
    GetPage(name: AppRoutes.favourites, page:()=> FavouritePage(),),
    GetPage(name: AppRoutes.notification, page:()=> NotificationPage(),),
    GetPage(name: AppRoutes.hoodies, page:()=> HoodiesPage(),),
    GetPage(name: AppRoutes.womenAccessories, page:()=>WomenAccessoriesPage(),),
    GetPage(name: AppRoutes.menAccessories, page:()=> MenAccessories(),),
    GetPage(name: AppRoutes.bags, page:()=> BagsPage(),),
    GetPage(name: AppRoutes.productDetails, page:()=> ProductDetails(),
    binding: BindingsBuilder((){
      Get.lazyPut(() => ProductDetailsController());
    })
    ),

  ];
}
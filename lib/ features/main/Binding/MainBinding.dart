import 'package:get/get.dart';

import '../../Cart/Controller/cart_controller.dart';
import '../../Favourites/controller/favourite_controller.dart';
import '../../Products/controller/ProductController.dart';
import '../../Products/controller/ProductDetailsController.dart';
import '../../Profile/controller/profile_controller.dart';
import '../../Search/Controller/search_controller.dart';
import '../../home/controller/DrawerController.dart';
import '../../home/controller/Home_Controller.dart';
import '../Controller/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductController());
    Get.put(DrawerControllerX(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => FavouriteController());
    Get.lazyPut(() => ProductDetailsController());
  }
}
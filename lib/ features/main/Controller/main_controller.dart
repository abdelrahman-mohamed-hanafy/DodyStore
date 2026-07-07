import 'package:get/get.dart';

import '../../Cart/UI/Pages/cart_page.dart';
import '../../MyOrders/UI/My_Order_Page.dart';
import '../../Products/UI/pages/products_page.dart';
import '../../Products/controller/ProductController.dart';
import '../../Profile/UI/Pages/profile_page.dart';
import '../../home/UI/pages/Home_Page.dart';


class MainController extends GetxController{
  var currentIndex = 0.obs;
  final pages = [
        () => HomePage(),
        () => ProductsPage(),
        () => CartPage(),
        () => MyOrderPage(),
        () => ProfilePage(),
  ];

  void changeIndex(int index) {
    if(index!= 1)
      {
        final productController = Get.find<ProductController>();
        productController.clearSelectedCategory();
      }
    currentIndex.value = index;
  }
}
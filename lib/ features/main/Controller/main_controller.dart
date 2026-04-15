import 'package:get/get.dart';

import '../../Cart/UI/Pages/cart_page.dart';
import '../../MyOrders/UI/My_Order_Page.dart';
import '../../Products/UI/pages/products_page.dart';
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
    currentIndex.value = index;
  }
}
import 'package:hive_flutter/adapters.dart';

class HiveService {
  late Box<bool> firstTimeBox;
  late Box userNameBox;
  late Box productsBox;
  late Box homeProductsBox;
  late Box productDetailsBox;
  late Box homeCategoriesBox;
  late Box cartBox;
  late Box favouritesBox;
  Future<void> init() async {
    await Hive.initFlutter();
    firstTimeBox = await Hive.openBox<bool>('firstTime');
    productsBox = await Hive.openBox('products');
    homeProductsBox = await Hive.openBox('home_products');
    productDetailsBox = await Hive.openBox('product_details');
    homeCategoriesBox = await Hive.openBox('home_categories');
    cartBox = await Hive.openBox('cart');
    favouritesBox = await Hive.openBox('favourites');
    userNameBox = await Hive.openBox('user_name');
  }
  Future<bool> isFirstTime() async {
    bool isFirstTime = firstTimeBox.get('firstTime') ?? true;
    return isFirstTime;
    }
  Future<void> setFirstTime() async {
    await firstTimeBox.put('firstTime', false);
  }
}
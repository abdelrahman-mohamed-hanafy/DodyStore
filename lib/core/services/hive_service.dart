import 'package:hive_flutter/adapters.dart';

class HiveService {
  late Box<bool> firstTimeBox;
  late Box productsBox;
  Future<void> init() async {
    await Hive.initFlutter();
    firstTimeBox = await Hive.openBox<bool>('firstTime');
    productsBox = await Hive.openBox('products');
  }
  Future<bool> isFirstTime() async {
    bool isFirstTime = firstTimeBox.get('firstTime') ?? true;
    return isFirstTime;
    }
  Future<void> setFirstTime() async {
    await firstTimeBox.put('firstTime', false);
  }
}
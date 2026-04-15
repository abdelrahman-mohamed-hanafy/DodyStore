import 'package:get/get.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../home/Model/Category_Model.dart';
import '../Models/Product.dart';
import '../UI/states/Product_States.dart';

class ProductController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final supaService = Get.find<SupabaseService>();
  final products = <Product>[].obs;
  final state = Rx<ProductStates>(ProductIdle());
  final RxSet<String> favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    fetchCategories();
    fetchRandomProductsFromAllCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      state.value = ProductLoading();

      final result = await supaService.getCategoriesWithCount();

      if (result.isSuccess) {
        categories.value = (result.data as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        state.value = ProductSuccess('Success');
      } else {
        state.value = ProductError(result.error.toString());
      }
    } catch (e) {
      state.value = ProductError(e.toString());
    }
  }
  Future<void> fetchRandomProductsFromAllCategories() async {
    final result = await supaService.getProducts();

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    products.value = result.data!;
  }


  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }


  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }
}
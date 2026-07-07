import 'package:get/get.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../home/Model/Category_Model.dart';
import '../../main/Controller/main_controller.dart';
import '../Models/Product.dart';
import '../UI/states/Product_States.dart';

class ProductController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final supaService = Get.find<SupabaseService>();
  final mainController = Get.find<MainController>();
  final products = <Product>[].obs;
  final state = Rx<ProductStates>(ProductIdle());
  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxString selectedCategoryId = ''.obs;


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

   List<Product>fetchProductsByCategory(String categoryId)
  {
      final result = products.where((p) => p.categoryId == categoryId).toList();
      return result;
  }
  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }
  void toggleCategory(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = '';
    } else {
      selectedCategoryId.value = categoryId;
    }
  }

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
  }

  void clearSelectedCategory() {
    selectedCategoryId.value = '';
  }
  void toggleFavorite(String productId) {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }
}
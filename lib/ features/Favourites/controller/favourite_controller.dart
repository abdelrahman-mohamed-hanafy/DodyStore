import 'package:dody_store/core/services/hive_service.dart';
import 'package:get/get.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../Products/Models/Product.dart';
import '../../home/UI/states/home_states.dart';

class FavouriteController extends GetxController{
  final hive = Get.find<HiveService>();
  final supaService = Get.find<SupabaseService>();

  final favourites = <Product>[].obs;

  final state = Rx<HomeStates>(Idle());

  @override
  void onInit() {
    super.onInit();
    _init();
  }
  Future<void> _init() async {
    await loadFavouriteFromCache();

    if (favourites.isNotEmpty) {
      state.value = Success(favourites);
    }

    try {
      await fetchFavouriteProducts();

      state.value = Success(favourites);
    } catch (e) {
      if (favourites.isEmpty) {
        state.value = HomeError(e.toString());
      }
    }
  }
  // refresh favourite products from supabase and cache them
  Future<void> refreshFavourite() async {
    await fetchFavouriteProducts();
  }
  // load favourite products from cache
  Future<void> loadFavouriteFromCache() async {
    favourites.value = hive.favouriteProductsBox.values
        .map(
          (e) => Product.fromJson(
        e['id'],
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  // fetch favourite products from supabase and cache them
  Future<void> fetchFavouriteProducts() async {
    final result = await supaService.getFavouriteProducts();

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    favourites.assignAll(result.data!);

    await cacheFavouriteProducts();
  }
  // cache favourite products to hive
  Future<void> cacheFavouriteProducts() async {
    await hive.favouriteProductsBox.clear();

    for (final product in favourites) {
      await hive.favouriteProductsBox.put(
        product.id,
        product.toJson(),
      );
    }
  }
  // check if product is favourite
  bool isFavourite(String productId) {
    return favourites.any(
          (e) => e.id == productId,
    );
  }
  // get favouriteProducts => favourites;
  int get favouriteCount => favourites.length;
  // add product to favourites
  Future<void> addFavourite(Product product) async {
    final result = await supaService.addFavourite(product.id);

    if (!result.isSuccess) {
      Get.snackbar(
        "Error",
        result.error!,
      );
      return;
    }

    if (!isFavourite(product.id)) {
      favourites.add(product);
    }

    await hive.favouriteProductsBox.put(
      product.id,
      product.toJson(),
    );
  }
  // remove favourite product from the list and cache
  Future<void> removeFavourite(Product product) async {
    final result = await supaService.removeFavourite(product.id);

    if (!result.isSuccess) {
      Get.snackbar(
        "Error",
        result.error!,
      );
      return;
    }

    favourites.removeWhere(
          (e) => e.id == product.id,
    );

    await hive.favouriteProductsBox.delete(
      product.id,
    );
  }
  // toggle favourite product
  Future<void> toggleFavourite(Product product) async {
    if (isFavourite(product.id)) {
      await removeFavourite(product);
    } else {
      await addFavourite(product);
    }
  }


}
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../ features/Products/Models/Product.dart';
import '../../ features/home/UI/states/ApiResult.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  ////  HOME PAGE /////

  // ================= CATEGORIES =================
  Future<ApiResult<List<Map<String, dynamic>>>> getCategoriesWithCount() async {
    try {
      final response = await supabase.rpc('get_categories_with_count');

      return ApiResult(
        data: List<Map<String, dynamic>>.from(response),
      );
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  // ================= RANDOM / ALL PRODUCTS =================
  Future<ApiResult<List<Product>>> getProducts({int? limit}) async {
    try {
      List response;

      if (limit != null) {
        response = await supabase.rpc(
          'get_random_products',
          params: {'limit_count': limit},
        );
      } else {
        response = await supabase
            .from('products')
            .select();
      }

      final products = response
          .map((e) => Product.fromJson(e['id'], e))
          .toList();

      return ApiResult(data: products);

    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  //// PRODUCT PAGE ////
  Future<ApiResult<Product?>> getProductById(String id) async {
    try {
      final response = await supabase
          .from('products')
          .select('*, categories(name)')
          .eq('id', id)
          .single();

      return ApiResult(
        data: Product.fromJson(response['id'], response),
      );
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }
  Future<String?> uploadProfileImage(File file, String userId) async {
    try {
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage
          .from('public_profiles')
          .upload(
        fileName,
        file,
        fileOptions: const FileOptions(
          upsert: true,
        ),
      );

      final url = supabase.storage
          .from('public_profiles')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  String getPublicProfileImage(String userId) {
    return supabase.storage
        .from('public_profiles')
        .getPublicUrl('$userId.jpg');
  }
}
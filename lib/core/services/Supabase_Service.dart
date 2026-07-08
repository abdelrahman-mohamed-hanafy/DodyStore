import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../ features/Products/Models/Product.dart';
import '../../ features/home/Model/OfferModel.dart';
import '../../ features/home/UI/states/ApiResult.dart';
import '../share/Models/UserModel.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // Authentication methods
  // ================= SIGN UP =================
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await supabase.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(mapAuthError(e));
    }
  }
  // ================= LOGIN =================
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      return await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception(mapAuthError(e));
    }
  }
  // ================= LOGOUT =================
  Future<void> logout() async {
    await supabase.auth.signOut();

    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }
  // ================= GET CURRENT USER =================
  User? get currentUser => supabase.auth.currentUser;
  // ================= Is Logged In =================
  bool get isLoggedIn => currentUser != null;
  // ================= SEND PASSWORD RESET EMAIL =================
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(mapAuthError(e));
    }
  }
  // ================= SIGN IN WITH GOOGLE =================
  Future<AuthResponse> signInWithGoogle() async {
    const webClientId = '865621798465-4rlon3svkljfs2dn16ab1vqqlvf1o2cu.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(
      serverClientId: webClientId,
    );

    final GoogleSignInAccount googleUser =
    await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    if (googleAuth.idToken == null) {
      throw Exception("Failed to get Google ID Token");
    }

    return await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
    );

  }
  // ================= SIGN IN WITH FACEBOOK =================
  Future<void> signInWithFacebook() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: 'devcode://facebook-logins',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }
  //  ================= Error Mapper =================

  String mapAuthError(AuthException e) {
    final message = e.message.toLowerCase().trim();

    // =========================
    // Login
    // =========================

    if (message.contains('invalid login credentials')) {
      return 'Incorrect email or password';
    }

    if (message.contains('email not confirmed')) {
      return 'Please verify your email first';
    }

    if (message.contains('user not found')) {
      return 'No account found with this email';
    }

    if (message.contains('anonymous sign-ins are disabled')) {
      return 'Anonymous sign in is disabled';
    }

    // =========================
    // Register
    // =========================

    if (message.contains('user already registered')) {
      return 'Email already in use';
    }

    if (message.contains('email address is invalid')) {
      return 'Invalid email format';
    }

    if (message.contains('password should be at least')) {
      return 'Password is too weak';
    }

    if (message.contains('signup is disabled')) {
      return 'Registration is currently disabled';
    }

    if (message.contains('email rate limit exceeded')) {
      return 'Too many emails sent. Try again later';
    }

    // =========================
    // Password Reset
    // =========================

    if (message.contains('unable to validate email address')) {
      return 'Invalid email format';
    }

    if (message.contains('password recovery is disabled')) {
      return 'Password recovery is disabled';
    }

    // =========================
    // Google / Facebook OAuth
    // =========================

    if (message.contains('provider is not enabled')) {
      return 'This sign-in method is not enabled';
    }

    if (message.contains('oauth')) {
      return 'Social login failed';
    }

    if (message.contains('identity already exists')) {
      return 'This social account is already linked';
    }

    if (message.contains('identity not found')) {
      return 'Social account not found';
    }

    if (message.contains('account linking')) {
      return 'Account linking failed';
    }

    if (message.contains('email conflict')) {
      return 'This email is already registered with another sign-in method';
    }

    if (message.contains('provider email needs verification')) {
      return 'Please verify your social account email';
    }

    // =========================
    // Session / JWT
    // =========================

    if (message.contains('jwt')) {
      return 'Session expired, please login again';
    }

    if (message.contains('invalid jwt')) {
      return 'Session expired, please login again';
    }

    if (message.contains('refresh token')) {
      return 'Session expired, please login again';
    }

    if (message.contains('token has expired')) {
      return 'Session expired, please login again';
    }

    if (message.contains('session not found')) {
      return 'Session expired, please login again';
    }

    // =========================
    // Rate Limits
    // =========================

    if (message.contains('rate limit')) {
      return 'Too many attempts, try again later';
    }

    if (message.contains('too many requests')) {
      return 'Too many attempts, try again later';
    }

    if (message.contains('over request rate limit')) {
      return 'Too many attempts, try again later';
    }

    // =========================
    // Network
    // =========================

    if (message.contains('socketexception')) {
      return 'Check your internet connection';
    }

    if (message.contains('network')) {
      return 'Check your internet connection';
    }

    if (message.contains('timeout')) {
      return 'Connection timed out';
    }

    if (message.contains('failed host lookup')) {
      return 'Check your internet connection';
    }

    // =========================
    // Permissions
    // =========================

    if (message.contains('permission denied')) {
      return 'Permission denied';
    }

    if (message.contains('row level security')) {
      return 'Access denied';
    }

    if (message.contains('not authorized')) {
      return 'You are not authorized';
    }

    // =========================
    // Storage
    // =========================

    if (message.contains('bucket not found')) {
      return 'Storage bucket not found';
    }

    if (message.contains('file size')) {
      return 'File size is too large';
    }

    if (message.contains('mime type')) {
      return 'Unsupported file type';
    }

    // =========================
    // Default
    // =========================

    return e.message;
  }

  //Link current user with credential



  ////  HOME PAGE /////

  // Get Offers
  Future<ApiResult<List<OfferModel>>> getOffers() async {
    try {
      final response = await supabase
          .from('offers')
          .select()
          .order('priority', ascending: false);

      final offers = response
          .map<OfferModel>((e) => OfferModel.fromJson(e))
          .toList();

      return ApiResult(data: offers);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }


  // Get Current User Profile
  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    return UserModel.fromSupabase(user);
  }

  // ================= CATEGORIES =================
  Future<ApiResult<List<Map<String, dynamic>>>> getCategoriesWithCount() async {
    try {
      final response = await supabase
          .from('categories')
          .select();

      return ApiResult(
        data: List<Map<String, dynamic>>.from(response),
      );
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  // ================= HOME PRODUCTS =================
  // Get Featured Products
  Future<ApiResult<List<Product>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('is_active', true)
          .eq('is_featured', true)
          .order('featured_priority')
          .limit(limit);

      final products = response
          .map<Product>((e) => Product.fromJson(e['id'], e))
          .toList();

      return ApiResult(data: products);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }
  //  Get New Products
  Future<ApiResult<List<Product>>> getNewProducts({
    int limit = 10,
  }) async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('is_active', true)
          .eq('is_new', true)
          .order(
        'created_at',
        ascending: false,
      )
          .limit(limit);

      final products = response
          .map<Product>((e) => Product.fromJson(e['id'], e))
          .toList();

      return ApiResult(data: products);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }
  //  Get Products Best Sellers
  Future<ApiResult<List<Product>>> getBestSellerProducts({
    int limit = 10,
  }) async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('is_active', true)
          .order(
        'sold_count',
        ascending: false,
      )
          .limit(limit);

      final products = response
          .map<Product>((e) => Product.fromJson(e['id'], e))
          .toList();

      return ApiResult(data: products);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }
  //  Get Products Deals
  Future<ApiResult<List<Product>>> getDealsProducts({
    int limit = 10,
  }) async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('is_active', true)
          .gt('old_price', 0)
          .order(
        'featured_priority',
      )
          .limit(limit);

      final products = response
          .map<Product>((e) => Product.fromJson(e['id'], e))
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
  // Favorite Products
  // get favorite products
  Future<ApiResult<List<Product>>> getFavouriteProducts() async {
    try {
      final response = await supabase
          .from('favorites')
          .select('products(*)');

      final products = response
          .map<Product>(
            (e) => Product.fromJson(
          e['products']['id'],
          e['products'],
        ),
      )
          .toList();

      return ApiResult(data: products);
    } catch (e) {
      return ApiResult(
        error: e.toString(),
      );
    }
  }
  // add to favorites
  Future<ApiResult<void>> addFavourite(
      String productId,
      ) async {
    try {
      await supabase
          .from('favorites')
          .insert({
        'user_id': supabase.auth.currentUser!.id,
        'product_id': productId,
      });

      return ApiResult();
    } catch (e) {
      return ApiResult(
        error: e.toString(),
      );
    }
  }
// remove from favorites
  Future<ApiResult<void>> removeFavourite(
      String productId,
      ) async {
    try {
      await supabase
          .from('favorites')
          .delete()
          .eq(
        'user_id',
        supabase.auth.currentUser!.id,
      )
          .eq(
        'product_id',
        productId,
      );

      return ApiResult();
    } catch (e) {
      return ApiResult(
        error: e.toString(),
      );
    }
  }


  Future<ApiResult<int>> getPromoDiscount(String code) async {
    try {
      final response = await supabase
          .from('promo_codes')
          .select()
          .eq('code', code.toUpperCase())
          .eq('active', true)
          .maybeSingle();

      if (response == null) {
        return ApiResult(error: 'Promo code not found');
      }

      return ApiResult(
        data: response['discount'] as int,
      );
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }
  Future<double> getShippingPrice() async {
    final response = await supabase
        .from('app_settings')
        .select()
        .single();

    return (response['shipping_price'] as num).toDouble();
  }
  String getPublicProfileImage(String userId) {
    return supabase.storage
        .from('public_profiles')
        .getPublicUrl('$userId.jpg');
  }

}
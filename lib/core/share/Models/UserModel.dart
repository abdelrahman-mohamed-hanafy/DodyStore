import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  factory UserModel.fromSupabase(User user) {
    final metadata = user.userMetadata ?? {};

    return UserModel(
      id: user.id,
      name: metadata['display_name'] ??
          metadata['full_name'] ??
          metadata['name'] ??
          user.email?.split('@').first ??
          'Guest',
      email: user.email ?? '',
      imageUrl: metadata['avatar_url'] ??
          metadata['picture'],
    );
  }
}
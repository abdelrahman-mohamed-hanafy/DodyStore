import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static Future<void> init() async {
    await Firebase.initializeApp();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==============================
  // 🔹 Sign Up
  // ==============================
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  // ==============================
  // 🔹 Login
  // ==============================
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  // ==============================
  // 🔹 Google Sign-In
  // ==============================
  Future<UserCredential?> signInWithGoogle() async {
    // اهم سطرين علشان الكود ميضربش
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return await _handleAccountExists(e);
      }
      throw Exception(_mapFirebaseError(e));
    }
  }

  // ==============================
  // 🔹 Facebook Sign-In
  // ==============================
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) return null;

      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return await _handleAccountExists(e);
      }
      throw Exception(_mapFirebaseError(e));
    }
  }

  // ==============================
  // 🔹 Handle account linking (NEW WAY)
  // ==============================
  Future<UserCredential?> _handleAccountExists(FirebaseAuthException e) async {
    final pendingCredential = e.credential;
    final email = e.email;

    if (pendingCredential == null || email == null) {
      throw Exception("Authentication conflict occurred");
    }
    throw Exception(
      "This email is already registered with another method. Please login using the original method, then link accounts.",
    );
  }

  // ==============================
  // 🔹 Link current user with credential
  // ==============================
  Future<void> linkWithCredential(AuthCredential credential) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No logged in user to link with");
    }

    try {
      await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  // ==============================
  // 🔹 Password Reset
  // ==============================
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  // ==============================
  // 🔹 Logout
  // ==============================
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();
  }

  // ==============================
  // 🔹 Current User
  // ==============================
  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  // ==============================
  // 🔹 Error Mapper
  // ==============================
  String _normalizeAuthCode(String code) {
    if (code.startsWith('auth/')) {
      return code.substring(5);
    }
    return code;
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    final code = _normalizeAuthCode(e.code);

    switch (code) {
      // =========================
      // Sign in
      // =========================
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return "Incorrect email or password";

      case 'user-disabled':
        return "This account has been disabled";

      case 'too-many-requests':
        return "Too many attempts, try again later";

      case 'network-request-failed':
        return "Check your internet connection";

      // =========================
      // Sign up
      // =========================
      case 'email-already-in-use':
        return "Email already in use";

      case 'invalid-email':
        return "Invalid email format";

      case 'weak-password':
        return "Password is too weak";

      // =========================
      // Account linking / social login
      // =========================
      case 'account-exists-with-different-credential':
        return "This email is already registered with another sign-in method";

      case 'credential-already-in-use':
        return "This credential is already linked to another account";

      case 'provider-already-linked':
        return "This provider is already linked";

      case 'requires-recent-login':
        return "Please login again and retry";

      case 'operation-not-allowed':
        return "This sign-in method is not enabled";

      default:
        return "Something went wrong";
    }
  }
  // ==============================
  // 🔹 Upload & Update Profile Image
  // ==============================
  Future<String?> uploadProfileImage(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    try {
      final ref = FirebaseStorage.instance
          .ref('profile_images/${user.uid}.jpg');

      final uploadTask = await ref.putFile(file);

      if (uploadTask.state == TaskState.success) {
        final url = await ref.getDownloadURL();

        await user.updatePhotoURL(url);
        await user.reload();

        return url;
      } else {
        throw Exception("Upload failed");
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Upload error');
    }
  }
}

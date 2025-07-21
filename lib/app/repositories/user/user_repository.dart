import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserRepository {
  Future<User?> register(String email, String password);

  Future<User?> loginWithEmailAndPassword(String email, String password);

  Future<void> forgotPassword(String email);

  Future<User?> googleLogin();

  Future<void> logout();

  Future<void> updateDisplayName(String name);

}
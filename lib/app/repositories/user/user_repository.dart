import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserRepository {
  Future<User?> register(String email, String password);

  Future<User?> loginWithEmailAndPassword(String email, String password);

}
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserService {
  Future<User?> register(String email, String password);
}

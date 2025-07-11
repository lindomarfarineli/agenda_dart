import 'package:agenda/app/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<User?> register(String email, String password) =>
      _userRepository.register(email, password);

  @override
  Future<User?> loginWithEmailPassword(String email, String password) =>
      _userRepository.loginWithEmailAndPassword(email, password);
      
  @override
  Future<void> forgotPassword(String email) => _userRepository.forgotPassword(email);
  
  @override
  Future<User?> googleSingnIn() => _userRepository.googleLogin();
  
  @override
  Future<void> googleLogOut() => _userRepository.googleLogOut();
}

import 'package:agenda/app/core/notifier/default_change_notifier.dart';
import 'package:agenda/app/exceptions/auth_exception.dart';
import 'package:agenda/app/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;

  LoginController({required UserService userService})
      : _userService = userService;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final user = await _userService.loginWithEmailPassword(email, password);

      if (user != null) {
        success();
      } else {
        setError('usuário ou senha inválidos');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}

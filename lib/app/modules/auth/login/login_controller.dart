import 'package:agenda/app/core/notifier/default_change_notifier.dart';
import 'package:agenda/app/exceptions/auth_exception.dart';
import 'package:agenda/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({required UserService userService})
      : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> googleLogin() async{
    try {
  showLoadingAndResetState();
  infoMessage = null;
  notifyListeners();
  final user = await _userService.googleSingnIn();
  
  if (user != null) {
    success();
  } else {
    _userService.logout;
    setError("erro ao realizar login com google");
  }
} on AuthException catch (e) {

  setError(e.message);
  _userService.logout();
}finally{
  hideLoading();
  notifyListeners();
}

  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
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

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      await _userService.forgotPassword(email);
      infoMessage = 'Se existir uma conta com este e-mail, um link de redefinição de senha foi enviado para ela.';
    } on AuthException catch (e){
      setError(e.message);
    } catch (e) {
      
      setError('erro ao resertar a senha');
           
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}

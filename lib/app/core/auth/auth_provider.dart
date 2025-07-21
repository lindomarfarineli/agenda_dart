import 'package:agenda/app/core/navigator/agenda_navigator.dart';
import 'package:agenda/app/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Importe este pacote

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;

  AuthProvider({
    required firebaseAuth,
    required userService,
  })  : _firebaseAuth = firebaseAuth,
        _userService = userService;

  Future<void> logout() => _userService.logout();

  User? get user => _firebaseAuth.currentUser;

  void loadListener() {
    // Adiciona um listener para userChanges, que notifica os ouvintes
    _firebaseAuth.userChanges().listen((_) => notifyListeners());

    // Adiciona um listener para idTokenChanges
    _firebaseAuth.idTokenChanges().listen((user) {
      // Agenda a navegação para depois que o frame atual for construído
      // Isso garante que o Navigator esteja pronto
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (user != null) {
          // Se o usuário estiver logado, navega para a home
          AgendaNavigator.to.pushNamedAndRemoveUntil('/home', (route) => false);
        } else {
          // Se o usuário não estiver logado, navega para o login
          AgendaNavigator.to
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
      });
    });
  }
}

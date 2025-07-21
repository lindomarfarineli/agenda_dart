import 'package:agenda/app/exceptions/auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      debugPrint('FirebaseAuthException code: ${e.code}');
      debugPrint('FirebaseAuthException message: ${e.message}');
      debugPrint('Stack trace: $s');

      // Captura o erro específico da sua Cloud Function
      if (e.code == 'already-in-use') {
        throw AuthException(
            message:
                'Uma conta com este e-mail já existe cadastrada com Email/Senha. '
                'Por favor, faça login com sua senha para vincular as contas.');
      }
      // Captura o erro padrão do Firebase para e-mail já em uso (se o bloqueio não for acionado por algum motivo)
      else if (e.code == 'email-already-in-use') {
        // Tenta logar com e-mail/senha se a conta já existe
        try {
          var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);
          return userCredential.user;
        } on FirebaseAuthException catch (f) {
          if (f.code == 'invalid-credential') {
            throw AuthException(
                message:
                    'Email e/ou senha incorretos. Tente novamente ou recupere a senha.');
          } else {
            // Para outros erros durante o signIn (ex: usuário desabilitado, etc.)
            throw AuthException(
                message: f.message ??
                    'Erro ao tentar fazer login com a conta existente.');
          }
        }
      }
      // Captura o erro "internal" da sua Cloud Function
      else if (e.code == 'internal') {
        throw AuthException(
            message:
                'Erro interno no processo de autenticação. Tente novamente mais tarde.');
      }
      // Para outros erros padrão do Firebase Auth durante o registro
      else if (e.code == 'weak-password') {
        throw AuthException(message: 'A senha fornecida é muito fraca.');
      } else if (e.code == 'invalid-email') {
        throw AuthException(message: 'O endereço de e-mail não é válido.');
      } else {
        // Para qualquer outro erro não esperado
        throw AuthException(
            message: e.message ??
                'Erro desconhecido ao registrar usuário, tente novamente...');
      }
    }
  }
  

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      
      final userCredencial = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);         
     
      return userCredencial.user;
    } on PlatformException catch (e) {      
      debugPrint('$e');
      
      throw AuthException(message: e.message ?? 'erro ao realizar login');
    } on FirebaseAuthException catch (e) {
      
      debugPrint('$e');     

      if (e.code == 'invalid-credential') {
       
        throw AuthException(message: 'Login ou senha invállidos, relembre sua senha ou tente outro método de login');
      } else {
        throw AuthException(message: e.message ?? 'erro ao realizar login');
      }
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      //toda a lógica anterior foi pensada para obter os erros, porém
      // firebase não envia mais tais erros, apensa dá sucesso por segurança
      // evitando a enumeração de emails por hackers.
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Captura exceções específicas do Firebase Auth
      debugPrint(
          'FirebaseAuthException code: ${e.code}, message: ${e.message}');

      switch (e.code) {
        case 'user-not-found':
          throw AuthException(message: 'Este email não está cadastrado.');
        case 'invalid-email':
          throw AuthException(message: 'O formato do email é inválido.');
        case 'auth/invalid-credential': // Pode ocorrer se houver problemas com credenciais federadas
        case 'auth/account-exists-with-different-credential': // Se o email foi registrado com Google, Facebook etc.
          throw AuthException(
              message:
                  "Este cadastro foi realizado com um provedor diferente. Senha não pode ser resetada diretamente.");
        case 'too-many-requests':
          throw AuthException(
              message:
                  "Muitas tentativas. Por favor, tente novamente mais tarde.");
        default:
          // Para outros erros não previstos especificamente
          throw AuthException(message: 'Erro ao redefinir senha: ${e.message}');
      }
    } on PlatformException catch (e) {
      debugPrint('$e');
      throw AuthException(message: 'erro ao resetar senha');
    } catch (e) {
      debugPrint('$e');
      throw AuthException(message: 'erro interno');
    }
  }

  @override
  Future<User?> googleLogin() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        
        final googleAuth = await googleUser.authentication;
        final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        // Tenta fazer login com as credenciais do Google no Firebase
        var userCredential =
            await _firebaseAuth.signInWithCredential(firebaseCredential);

        return userCredential.user;
      }
      return null; // Retorna null se o usuário cancelar o login do Google
    } on FirebaseAuthException catch (e) {
      
      bool validate = false;
      if (e.message != null) {
        if (e.message!.contains('[ Error code:47 ]')) {
          validate = true;
        } else {
          validate = false;
        }
      } else {
        validate = false;
      }
      // --- Tratamento de Erros Personalizado ---
      
      if (e.code ==
              'permission-denied' || // Código que sua Cloud Function está enviando
          e.code ==
              'already-in-use' || // Código genérico ou antigo que poderia ter vindo
          e.code == 'internal' ||
          validate) {
        // Erro interno do Firebase ao processar a função

        throw AuthException(
            message:
                'Uma conta com este e-mail já existe cadastrada com Email/Senha. '
                'Por favor, faça login com sua senha ou use a recuperação de senha.');
      }      
      else {
        
        throw AuthException(
            message:
                e.message ?? 'Erro desconhecido ao fazer login com o Google.');
      }
    } catch (e) {
      // Captura quaisquer outros tipos de erros que não sejam FirebaseAuthException      
      throw AuthException(
          message: 'Ocorreu um erro inesperado ao fazer login com o Google.');
    }
  }  

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }
  
  @override
  Future<void> updateDisplayName(String name)async {
    final user = _firebaseAuth.currentUser;
    if(user != null){
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}

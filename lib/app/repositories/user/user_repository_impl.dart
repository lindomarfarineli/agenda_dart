import 'package:agenda/app/exceptions/auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      var userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      debugPrint('$e');
      debugPrint('$s');

      //email-already-exists
      if (e.code == 'email-already-in-use') {
        try {
          var userCredencial = await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);
          return userCredencial.user;
        } on FirebaseAuthException catch (f) {
          if (f.code == 'invalid-credential') {
            throw AuthException(
                message:
                    'email já utilizado. Escolha outro email ou tente recuperar a senha!');
          } else {
            throw AuthException(
                message:
                    'você se cadastrou por meio do google, utilize esse modo para entrar.');
          }
        }
      } else {
        throw AuthException(
            message:
                e.message ?? 'Erro ao registrar usuário, tente novamente...');
      }
    }
  }

  @override
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on PlatformException catch (e, s) {
      debugPrint('$e');
      debugPrint('$s');
      throw AuthException(message: e.message ?? 'erro ao realizar login');
    } on FirebaseAuthException catch (e, s) {      
      debugPrint('$e');
      debugPrint('$s');
      print('*************************************************************************************');
      print(e.code);
      print('****************************************************************************************');
      if (e.code == 'invalid-credential') {
        print('*******************entrou aqui************************************');
        //throw AuthException(message:'email já utilizado. Escolha outro email ou tente recuperar a senha!');
        throw AuthException(message:'Login ou senha invállidos');
      } else {
        throw AuthException(message: e.message ?? 'erro ao realizar login');
      }
        
    }
  }
}


import 'package:agenda/app/core/modules/agenda_module.dart';
import 'package:agenda/app/modules/auth/login/login_controller.dart';
import 'package:agenda/app/modules/auth/login/login_page.dart';
import 'package:agenda/app/modules/auth/register/register_controller.dart';
import 'package:agenda/app/modules/auth/register/register_page.dart';


import 'package:provider/provider.dart';


class AuthModule extends AgendaModules {


  AuthModule() : super(
    bindings: [
      ChangeNotifierProvider(create: (context) => LoginController(userService: context.read())),
      ChangeNotifierProvider(create: (context) => RegisterController(userService: context.read())),
    ],
    routers: {
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
    },    
  );
  
}
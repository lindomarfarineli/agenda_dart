import 'package:agenda/app/app_widget.dart';
import 'package:agenda/app/core/auth/auth_provider.dart' as auth;
import 'package:agenda/app/core/database/sqlite_connection_factory.dart';
import 'package:agenda/app/repositories/user/user_repository.dart';
import 'package:agenda/app/repositories/user/user_repository_impl.dart';
import 'package:agenda/app/services/user/user_service.dart';
import 'package:agenda/app/services/user/user_service_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppModule extends StatelessWidget {
  const AppModule({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
        Provider(
          create: (__) => SqliteConnectionFactory(), 
          lazy: false),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(firebaseAuth: context.read()),
          lazy: false,
        ),
        Provider<UserService>(
          create: (context) =>
          UserServiceImpl(userRepository: context.read()),
          lazy: false,),
        ChangeNotifierProvider(create: (context) =>
         auth.AuthProvider(firebaseAuth: context.read<FirebaseAuth>(), userService: context.read<UserService>())
         ..loadListener(),
         lazy: false,
        )
      ],
      child: const AppWidget(),
    );
  }
}

import 'package:agenda/app/app_widget.dart';
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
        Provider(create: (_) => FirebaseAuth.instance),
        Provider(create: (__) => SqliteConnectionFactory(), lazy: false),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(firebaseAuth: context.read()),
        ),
        Provider<UserService>(
          create: (context) => UserServiceImpl(userRepository: context.read()),
        ),
      ],
      child: const AppWidget(),
    );
  }
}

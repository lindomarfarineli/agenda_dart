
import 'package:agenda/app/core/database/sqlite_adm_connection.dart';
import 'package:agenda/app/core/ui/ui_config.dart';
import 'package:agenda/app/models/splash/splash_page.dart';
import 'package:agenda/app/modules/auth/auth_module.dart';
import 'package:agenda/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';


class AppWidget extends StatefulWidget {

  const AppWidget({ super.key });

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

   final sqliteAdm = SqliteAdmConnection();

   final app = main();

   @override
   initState()  {
    super.initState();
    final auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addObserver(sqliteAdm);
   }

   @override
   void dispose(){
    WidgetsBinding.instance.removeObserver(sqliteAdm);
    super.dispose();
   }
   

   @override
   Widget build(BuildContext context) {
       
       return MaterialApp(
        title: 'Agenda',
        debugShowCheckedModeBanner: false,  
        theme: UiConfig.theme,      
        initialRoute: '/login',
        routes: {
          ...AuthModule().routers
        },
        home: const SplashPage(),
       );
  }
}
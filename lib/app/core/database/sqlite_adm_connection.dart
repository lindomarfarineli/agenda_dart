
import 'package:agenda/app/core/database/sqlite_connection_factory.dart';
import 'package:flutter/material.dart';

class SqliteAdmConnection with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    final connection = SqliteConnectionFactory();
   
    switch(state){
      case AppLifecycleState.resumed:
      case AppLifecycleState.hidden:      
        break;      
      case AppLifecycleState.detached:        
      case AppLifecycleState.inactive:         
      case AppLifecycleState.paused:
        connection.closeConnection();
        break;
      
       
    }

    super.didChangeAppLifecycleState(state);
  }
  
}
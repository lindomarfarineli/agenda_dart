import 'package:agenda/app/core/widget/agenda_logo.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {

  const SplashPage({ super.key });

   @override
   Widget build(BuildContext context) {
       return const Scaffold(
           
           body: Center(
            child: AgendaLogo(),
           ),
       );
  }
}
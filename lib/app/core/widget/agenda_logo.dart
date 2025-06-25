import 'package:flutter/material.dart';
import 'package:agenda/app/core/ui/theme_extension.dart' as theme;

class AgendaLogo extends StatelessWidget {

  const AgendaLogo({ super.key });

   @override
   Widget build(BuildContext context) {
       return Padding(
         padding: const EdgeInsets.only(top: 3.0),
         child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Image.asset('assets/logo.png', height: 200,),
              Text('Agenda', style: context.textTheme.titleLarge ),
             ],
         ),
       );
  }
}
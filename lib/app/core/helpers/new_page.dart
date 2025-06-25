import 'package:flutter/material.dart';

class NewPage {


  final String page;
  final BuildContext context;


  NewPage({
    required this.page,
    required this.context,
  });

  static void change({required context,  required page}){
     Navigator.of(context).pushNamed(page);
  }

  static void pop({required context}){
     Navigator.pop(context);
  }
  
}

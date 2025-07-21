import 'package:agenda/app/modules/home/widgets/home_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(        
        title: const Text('Home Page'),
      ),
      body: Container(),
    );
  }
}

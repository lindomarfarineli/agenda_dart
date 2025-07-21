import 'package:agenda/app/core/ui/agenda_icons.dart';
import 'package:agenda/app/core/ui/theme_extension.dart';
import 'package:agenda/app/modules/home/widgets/home_drawer.dart';
import 'package:agenda/app/modules/home/widgets/home_filters.dart';
import 'package:agenda/app/modules/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            icon: Icon(
              AgendaIcons.filter,
              color: context.primaryColor,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem<bool>(
                child: Text('Mostras Atividades concluídas'),
              ),
            ],
          ),
        ],
        //backgroundColor: Color(0xFFFAFBFE)
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(),
                      HomeFilters(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

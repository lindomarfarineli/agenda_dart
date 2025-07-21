import 'package:agenda/app/core/ui/theme_extension.dart';
import 'package:flutter/material.dart';

class CardFilter extends StatefulWidget {
  const CardFilter({super.key});

  @override
  State<CardFilter> createState() => _CardFilterState();
}

class _CardFilterState extends State<CardFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120, maxWidth: 150),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.primaryColor,
        border: Border.all(
          color: Colors.grey.withOpacity(0.8),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text('10 ATIVIDADES', style: context.titleStyle.copyWith(fontSize: 10, color: Colors.white),),
          Text('HOJE', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )),
          LinearProgressIndicator(
            backgroundColor: context.primaryColorLight,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            value: 0.4,
          )
        ],
      ),
    );
  }
}

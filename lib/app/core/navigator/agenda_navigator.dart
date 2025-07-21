
import 'package:flutter/material.dart';

class AgendaNavigator {
  AgendaNavigator._();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState get to => navigatorKey.currentState!;
}
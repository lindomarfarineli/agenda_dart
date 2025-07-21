import 'package:agenda/app/core/modules/agenda_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

abstract class AgendaModules {
  final Map<String, WidgetBuilder> _routers;
  final List<SingleChildWidget>? _bindings;

  AgendaModules({
    required Map<String, WidgetBuilder> routers,
    List<SingleChildWidget>? bindings
  }) : _routers = routers, _bindings = bindings;

  Map<String, WidgetBuilder> get routers{
    return _routers.map((key, pageBuilder) => MapEntry(key, (_) => AgendaPage(
      bindings: _bindings,
      page:  pageBuilder,
    )));
  }
}
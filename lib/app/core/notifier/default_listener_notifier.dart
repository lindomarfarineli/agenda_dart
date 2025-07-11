import 'package:agenda/app/core/notifier/default_change_notifier.dart';
import 'package:agenda/app/core/ui/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener(
      {required BuildContext context,
      required SucessVoidCallback succesCallback,
      EveryCallback? everyCallback,
      ErrorVoidCallback? errorCallback}) {
    changeNotifier.addListener(() {
      if (everyCallback != null) {
        everyCallback(changeNotifier, this);
      }
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (errorCallback != null) {
          errorCallback(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'erro interno');
      } else if (changeNotifier.isSuccess) {
        succesCallback(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SucessVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef ErrorVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef EveryCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

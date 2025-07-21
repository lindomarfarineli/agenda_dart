import 'package:agenda/app/core/auth/auth_provider.dart';
import 'package:agenda/app/core/ui/messages.dart';
import 'package:agenda/app/core/ui/theme_extension.dart';
import 'package:agenda/app/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(70)),
            child: Row(children: [
              Selector<AuthProvider, String?>(
                selector: (context, authProvider) {
                  return authProvider.user?.photoURL;
                },
                builder: (_, photUrl, __) {

                  if(photUrl == null || photUrl.isEmpty){
                    return const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/logo.png'), 
                    );
                  } else {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(photUrl), radius: 30);
                  }                  
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Selector<AuthProvider, String>(
                    selector: (context, authProvider) {
                      return authProvider.user?.displayName ?? 'Não Informado';
                    },
                    builder: (_, value, __) {
                      return Text(value,
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold));
                    },
                  ),
                ),
              ),
            ]),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Alterar nome'),
                      content:
                          TextField(onChanged: (value) => nameVN.value = value),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              final name = nameVN.value;
                              if (name == '') {
                                Messages.of(context)
                                    .showError('Nome obrigatório');
                                    } else {
                                      Loader.show(context);
                                      await context.read<UserService>().updateDisplayName(name);
                                      Loader.hide();                                      
                                      Navigator.of(context).pop();
                                    }
                            },
                            child: const Text('Alterar'))
                      ],
                    );
                  });
            },
            title: const Text('Alterar nome'),
          ),
          ListTile(
            onTap: () => context.read<AuthProvider>().logout(),
            title: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

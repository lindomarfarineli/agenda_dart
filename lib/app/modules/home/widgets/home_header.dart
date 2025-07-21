import 'package:agenda/app/core/auth/auth_provider.dart';
import 'package:agenda/app/core/ui/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Selector<AuthProvider, String>(
            selector: (context, authProvider) =>
                authProvider.user?.displayName ?? "não informado",
            builder: (_, nameUser, __) {
              return Text(
                'E aí? $nameUser!',
                style: context.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ],
    );
  }
}

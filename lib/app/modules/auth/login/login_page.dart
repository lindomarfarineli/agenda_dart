
import 'package:agenda/app/core/helpers/new_page.dart';
import 'package:agenda/app/core/notifier/default_listener_notifier.dart';
import 'package:agenda/app/core/widget/agenda_field.dart';
import 'package:agenda/app/core/widget/agenda_logo.dart';
import 'package:agenda/app/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  

  @override
  void initState() {
    
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>()).
    listener(context: context, succesCallback: ((notifier, listenerInstance) {
      print('login efetuado com sucesso');
    }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const AgendaLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AgendaField(label: 'Email',
                            controller: _emailEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail Obrigatório'),
                              Validatorless.email('E-mail inválido')
                            ]),),                            
                            const SizedBox(
                              height: 20,
                            ),
                            AgendaField(label: 'Senha', 
                            controller: _passwordEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha Obrigatória'),
                              Validatorless.min(6, 'Senha tem pelo menos 6 caracteres')
                            ]),
                            obscureText: true,),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Esqueceu sua senha?'),
                                ),
                                ElevatedButton( 
                                  onPressed: () {
                                    final formValid = _formKey.currentState?.validate() ?? false;
                                    if (formValid){
                                      final email = _emailEC.text;
                                      final password = _passwordEC.text;
                                      context.read<LoginController>().loginWithEmailAndPassword(email, password);
                                    }
                                  },                                 
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),                                 
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Login'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF0F3F7),
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: 260,
                              child: SignInButton(
                                Buttons.Google,
                                text: 'continue com Google',
                                onPressed: () {},
                                padding: const EdgeInsets.all(5),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('  Não tem conta?'),
                                TextButton(
                                    onPressed: () {

                                      NewPage.change(context: context, page: '/register');

                                      //Navigator.of(context).pushNamed('/register');
                                    },
                                    child: const Text('Cadastre-se!'))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

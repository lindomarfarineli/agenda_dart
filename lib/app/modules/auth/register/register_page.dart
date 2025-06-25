import 'package:agenda/app/core/helpers/new_page.dart';
import 'package:agenda/app/core/notifier/default_listener_notifier.dart';
import 'package:agenda/app/core/ui/theme_extension.dart';
import 'package:agenda/app/core/validators/validators.dart';
import 'package:agenda/app/core/widget/agenda_field.dart';
import 'package:agenda/app/core/widget/agenda_logo.dart';
import 'package:agenda/app/modules/auth/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEc = TextEditingController();
  final _passwordEc = TextEditingController();
  final _confirmPasswordEc = TextEditingController();

  @override
  void dispose() {
    _emailEc.dispose();
    _passwordEc.dispose();
    _confirmPasswordEc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final defaultListener = DefaultListenerNotifier(
        changeNotifier: context.read<RegisterController>());

    defaultListener.listener(
      context: context,
      succesCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
        Navigator.of(context).pop();
      },
      errorCallback: (notifier, listenerInstance) => { 
        //implementar se necessário
      },
    );

    /*context.read<RegisterController>().addListener(() {
      final controller = context.read<RegisterController>();
      var sucess = controller.sucess;
      var error = controller.error;
      if (sucess) {
        Navigator.of(context).pop();
      } else if (error != null && error.isNotEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error),
          backgroundColor: Colors.red),
        );
      }
     });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agenda',
                style: TextStyle(
                  fontSize: 10,
                  color: context.primaryColor,
                ),
              ),
              Text(
                'Cadastro',
                strutStyle: StrutStyle.disabled,
                style: TextStyle(
                  fontSize: 15,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () {
            NewPage.pop(context: context);
          },
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 15,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: AgendaLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AgendaField(
                    label: 'Email',
                    controller: _emailEc,
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo email é obrigatório'),
                      Validatorless.email('Email inválido')
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AgendaField(
                    label: 'Senha',
                    obscureText: true,
                    controller: _passwordEc,
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo senha é obrigatório!'),
                      Validatorless.min(
                          6, 'Senha deve ter pelo menos 6 caractéres')
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AgendaField(
                    label: 'Confirme a Senha',
                    obscureText: true,
                    controller: _confirmPasswordEc,
                    validator: Validatorless.multiple([
                      Validatorless.required(
                          'Campo de confirmação é obrigatório!'),
                      Validators.compare(
                          _passwordEc, 'Senhas digitadas são diferentes')
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          context
                              .read<RegisterController>()
                              .registerUser(_emailEc.text, _passwordEc.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

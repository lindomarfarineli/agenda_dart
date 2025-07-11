import 'package:agenda/app/core/ui/eye_icons.dart';
import 'package:flutter/material.dart';


class AgendaField extends StatelessWidget {

  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  AgendaField({
    Key? key,
    required this.label,
    this.suffixIconButton,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.focusNode
  })  : assert(
          obscureText == true ? suffixIconButton == null : true,
          'obscureText e suffixIconButton não poder ser enviados ao mesmo tempo',
        ),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureTextVN,
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
           validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red)),
            isDense: true,
            suffixIcon: suffixIconButton ??
                (obscureText == true
                    ? IconButton(
                        onPressed: () {
                          obscureTextVN.value = !obscureTextValue;
                        },
                        icon: !obscureTextValue
                            ? const Icon(
                                Eye.eyeSlash,
                                size: 15,
                              )
                            : const Icon(
                                Eye.eye,
                                size: 15,
                              ),
                      )
                    : null),
          ),
          obscureText: obscureTextValue,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/colorTheme.dart';

class mytextField extends StatelessWidget {
  // dynamic value;

  mytextField({
    Key? key,
    // this.value,
    required this.hint,
    required this.regExpn,
    required this.contro,
    required this.hintLebel,
    required this.validateText,
    required this.finalvalidateText,
    required this.icodata,
    required this.autoval,
    required this.kybType
    // required this.inputFormatter
  }) : super(key: key);
  String validateText, finalvalidateText, hint, hintLebel, regExpn;
  IconData icodata;
  TextInputType kybType;
  List<TextInputFormatter>? inputFormatter;
  TextEditingController contro;
  AutovalidateMode autoval;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: TextFormField(
        keyboardType: kybType,
        autovalidateMode: autoval,
        validator: (emailValue) {
          if (emailValue!.isEmpty) {
            return validateText;
          }
          RegExp regExp = new RegExp(regExpn);
          if (regExp.hasMatch(emailValue)) {
            return null;
          }
          return finalvalidateText;
        },
        controller: contro,
        // initialValue: value,
        // inputFormatters: inputFormatter,
        decoration: InputDecoration(
          prefixIcon: Icon(icodata),
          labelText: hintLebel,
          hintText: hint,
          
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ColorTheme.m_blue),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
        ),
      ),
    );
  }
}

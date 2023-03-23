import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/colorTheme.dart';

class mytextField extends StatelessWidget {
  int? maxlength;

  // dynamic value;

  mytextField(
      {Key? key,
      // this.value,
      required this.hint,
      required this.regExpn,
      required this.contro,
      required this.hintLebel,
      this.maxlength,
      required this.validateText,
      this.prex,
      required this.finalvalidateText,
      required this.icodata,
      required this.autoval,
      this.numbererrotxt,
      required this.kybType,
      this.inputFormatter})
      : super(key: key);
  String? validateText,
      finalvalidateText,
      hint,
      hintLebel,
      regExpn,
      numbererrotxt;
  IconData icodata;
  Widget? prex;
  TextInputType kybType;
  List<TextInputFormatter>? inputFormatter;
  TextEditingController contro;
  AutovalidateMode autoval;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: TextFormField(
        keyboardType: kybType,
        autovalidateMode: autoval,
        validator: (Value) {
          if (Value!.isEmpty) {
            return validateText;
          } else if (maxlength! < 9) {
            return numbererrotxt;
          }
          RegExp regExp = new RegExp(regExpn!);
          if (regExp.hasMatch(Value)) {
            return null;
          }
          return finalvalidateText;
        },
        controller: contro,
        // initialValue: value,
        // maxLength: maxlength,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          prefixIcon: Icon(icodata),
          labelText: hintLebel,
          hintText: hint,
          prefix: prex,
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

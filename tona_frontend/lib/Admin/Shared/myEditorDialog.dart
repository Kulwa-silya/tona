import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/colorTheme.dart';
import 'myTextFormField.dart';

class myEditordialog extends StatefulWidget {
  String email;
  String uname;

  myEditordialog({Key? key, required this.email, required this.uname})
      : super(key: key);

  @override
  State<myEditordialog> createState() => _mydialogState();
}

class _mydialogState extends State<myEditordialog> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool saveAttempt = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 8),
                      child: Center(
                        child: Text(
                          "User Editor",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    mytextField(
                        contro: name,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "Fill the new Username",
                        hintLebel: "${widget.uname}",
                        validateText: "Fill in the Username",
                        finalvalidateText: "Invalid UserName Format",
                        icodata: Icons.person,
                        inputFormatter: [
                          FilteringTextInputFormatter.deny(
                              new RegExp(r"\s\b|\b\s"))
                        ],
                        regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                            "\\@" +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                            "(" +
                            "\\." +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                            ")+"),
                    mytextField(
                        contro: email,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "fill the new email",
                        hintLebel: "${widget.email}",
                        validateText: "Fill in your email",
                        finalvalidateText: "Invalid Email Format",
                        icodata: Icons.email,
                        inputFormatter: [
                          FilteringTextInputFormatter.deny(
                              new RegExp(r"\s\b|\b\s"))
                        ],
                        regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                            "\\@" +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                            "(" +
                            "\\." +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                            ")+"),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 25.0),
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Update',
                                style: TextStyle(fontWeight: FontWeight.w200),
                              )
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: ColorTheme.m_blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onPressed: () async {
                            setState(() {
                              saveAttempt = true;
                            });

                            if (formkey.currentState!.validate()) {
                              formkey.currentState!.save();
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

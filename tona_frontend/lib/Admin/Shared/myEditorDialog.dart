import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/colorTheme.dart';
import 'myTextFormField.dart';

class myEditordialog extends StatefulWidget {
  String? data1;
  String? data2;
  String? data3;
  String? data4;
  String? heading;

  myEditordialog(
      {Key? key, this.data1, this.heading, this.data2, this.data3, this.data4})
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
                          "${widget.heading}",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    widget.data1 != null
                        ? mytextField(
                          kybType: TextInputType.emailAddress,
                            contro: name,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "Fill the new Username",
                            hintLebel: "${widget.data1}",
                            validateText: "Fill in the Username",
                            finalvalidateText: "Invalid UserName Format",
                            icodata: Icons.person,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+")
                        : SizedBox.shrink(),
                    widget.data2 != null
                        ? mytextField(
                          kybType: TextInputType.emailAddress,
                            contro: email,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "fill the new email",
                            hintLebel: "${widget.data2}",
                            validateText: "Fill in your email",
                            finalvalidateText: "Invalid Email Format",
                            icodata: Icons.email,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+")
                        : SizedBox.shrink(),
                    widget.data3 != null
                        ? mytextField(
                          kybType: TextInputType.emailAddress,
                            contro: phone,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "fill the new phone",
                            hintLebel: "${widget.data3}",
                            validateText: "Fill in your phone",
                            finalvalidateText: "Invalid Phone Format",
                            icodata: Icons.email,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+")
                        : SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text(
                              'Close',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorTheme.m_red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Update',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
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

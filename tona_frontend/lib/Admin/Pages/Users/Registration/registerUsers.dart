import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machafuapp/Admin/Pages/Users/view.dart';
import 'package:machafuapp/Auth/signIn.dart';
import 'package:machafuapp/Admin/Pages/dashboard.dart';
import '../../../Shared/myTextFormField.dart';
import '../../../consts/colorTheme.dart';

class RegisterUsers extends StatefulWidget {
  const RegisterUsers({Key? key}) : super(key: key);

  @override
  State<RegisterUsers> createState() => _RegisterUsersState();
}

class _RegisterUsersState extends State<RegisterUsers> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool loading = false;

  bool saveAttempt = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UserConfig()));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    color: ColorTheme.m_blue,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                      ),
                    ))),
          ),
        ),
        elevation: 0,
        backgroundColor: ColorTheme.m_white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: ColorTheme.m_white,
          child: Column(
            children: [
              Form(
                key: formkey,
                child: Center(
                  child: Text(
                    "New User",
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
                  hint: "Ex: Norman",
                  hintLebel: "Full Name",
                  validateText: "Fill in your full name",
                  finalvalidateText: "Invalid Name Format",
                  icodata: Icons.person,
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
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
                  hint: "Ex: example@example.com",
                  hintLebel: "Email",
                  validateText: "Fill in your email",
                  finalvalidateText: "Invalid Email Format",
                  icodata: Icons.email,
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                  ],
                  regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      "\\@" +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                      "(" +
                      "\\." +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                      ")+"),
              mytextField(
                  contro: phone,
                  autoval: AutovalidateMode.onUserInteraction,
                  hint: "Ex: 0767.., +255767",
                  hintLebel: "Phone",
                  validateText: "Fill in your phone number",
                  finalvalidateText: "Invalid Phone Format",
                  icodata: Icons.phone,
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                  ],
                  regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      "\\@" +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                      "(" +
                      "\\." +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                      ")+"),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 60.0, vertical: 25.0),
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add',
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

                        setState(() => loading = true);
                        // displayDialog();
                        setState(() => loading = false);

                        // _login();

                      }

                      // _saveDeviceToken();

                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => Manager()));
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

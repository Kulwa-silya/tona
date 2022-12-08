import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machafuapp/Admin/Pages/Users/view.dart';
import '../../../Shared/myTextFormField.dart';
import 'package:http/http.dart' as http;
import '../../../consts/colorTheme.dart';

class RegisterUsers extends StatefulWidget {
  String axxton;
  RegisterUsers({Key? key, required this.axxton}) : super(key: key);

  @override
  State<RegisterUsers> createState() => _RegisterUsersState();
}

class _RegisterUsersState extends State<RegisterUsers> {
  TextEditingController uname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool loading = false;

  bool saveAttempt = false;

  @override
  void initState() {
    // print(widget.axxton);
    super.initState();
  }

  void _useradd() async {
    final response = await http
        .post(Uri.parse("https://tona-production.up.railway.app/auth/users/"),
            // headers: {
            //   HttpHeaders.authorizationHeader: "JWT ${widget.axxton}",
            // } ,
            body: {
          "username": uname.text,
          "password": pass.text,
          "email": email.text,
          "first_name": fname.text,
          "last_name": lname.text
        });
    var res = json.decode(response.body);

    print(res);

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil('/users', (route) => false);

//             Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (context) => UserConfig(acctok: widget.axxton,)),
//   (Route<dynamic> route) => false,
// );

            Navigator.pop(context);
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    UserConfig(acctok: widget.axxton)));
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => UserConfig(
            //           acctok: widget.axxton,
            //         )));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    color: ColorTheme.m_blue,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 10,
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
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "New User",
                        style: TextStyle(
                            color: ColorTheme.m_blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    mytextField(
                        contro: fname,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "Ex: Norman",
                        hintLebel: "First Name",
                        validateText: "Fill in your first name",
                        finalvalidateText: "Invalid Name Format",
                        icodata: Icons.person,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              new RegExp('[a-zA-Z]'))
                        ],
                        regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                    mytextField(
                        contro: lname,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "Ex: Mush",
                        hintLebel: "Last Name",
                        validateText: "Fill in your last name",
                        finalvalidateText: "Invalid Name Format",
                        icodata: Icons.person,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              new RegExp('[a-zA-Z]'))
                        ],
                        regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                    mytextField(
                        contro: uname,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "Ex: Bojo",
                        hintLebel: "Username",
                        validateText: "Fill in your username number",
                        finalvalidateText: "Invalid username Format",
                        icodata: Icons.nest_cam_wired_stand_outlined,
                        inputFormatter: [
                          FilteringTextInputFormatter.deny(
                              new RegExp(r"\s\b|\b\s"))
                        ],
                        regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                    mytextField(
                        contro: email,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "Ex: example@example.com",
                        hintLebel: "Email",
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
                    mytextField(
                        contro: pass,
                        autoval: AutovalidateMode.onUserInteraction,
                        hint: "Ex: *****",
                        hintLebel: "Password",
                        validateText: "Fill in your password number",
                        finalvalidateText: "Invalid Password Format",
                        icodata: Icons.password,
                        inputFormatter: [
                          FilteringTextInputFormatter.deny(
                              new RegExp(r"\s\b|\b\s"))
                        ],
                        regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 25.0),
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

                              _useradd();
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

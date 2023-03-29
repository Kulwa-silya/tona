import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machafuapp/Admin/Pages/Users/view.dart';
import '../../../Shared/myTextFormField.dart';
import 'package:http/http.dart' as http;
import '../../../consts/colorTheme.dart';

class RegisterUsers extends StatefulWidget {
  String  fname, lname, phone;
  RegisterUsers(
      {Key? key,

      required this.fname,
      required this.lname,
      required this.phone})
      : super(key: key);

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

  var jsonre;

  var errormsg;

  String? acctExisterrormsg;

  String infosms = "..";

  @override
  void initState() {
    uname.addListener(() {
      final text = uname.text;
      if (text.isNotEmpty && text.startsWith('0')) {
        uname.text = text.substring(1);
        uname.selection = TextSelection.fromPosition(
          TextPosition(offset: uname.text.length),
        );
      }
    });
    super.initState();
  }

  String? password;
  Future _useradd() async {
    password = lname.text.toUpperCase() +
        uname.text.trim().substring(uname.text.length - 4);
    final response = await http
        .post(
            Uri.parse(
                "https://tona-production.up.railway.app/auth/users/"),
            headers: {
              // HttpHeaders.authorizationHeader: "JWT ${widget.axxton}",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "first_name": fname.text,
              "last_name": lname.text,
              "phone_number": "+255${uname.text}",
              "password": password,
              "user_type": 2,
            }))
        .then((value) async {
      print(password);
      print(value);

      print(value.body);
      jsonre = jsonDecode(value.body);

      acctExisterrormsg = jsonre["phone_number"][0];

      if (acctExisterrormsg ==
          "user account with this phone number already exists.") {
        infosms = "User Already Exists";
      } else {
        infosms = "Added";
      }

      if (infosms == "Added") {
        fname.clear();
        lname.clear();
        uname.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "User Added",
              style: TextStyle(
                  color: ColorTheme.m_blue, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: ColorTheme.m_blue_mpauko_zaidi,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 30,
          duration: Duration(milliseconds: 2000),
          padding: EdgeInsets.all(3),
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: ColorTheme.m_blue,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //Do whatever you want
            },
          ),
        ));
      } else {
        await showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0)), //this right here
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 8),
                          child: Center(
                            child: Text(
                              "Info!",
                              style: TextStyle(
                                  color: ColorTheme.m_blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("$infosms"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ok',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    )
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorTheme.m_blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    saveAttempt = true;
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }

      // setState(()  {
      //   acctExisterrormsg = jsonre['phone_number'];
      //   print("acctex ni: $acctExisterrormsg");

      // });
    }).catchError((errsms) {
      print(errsms);
    });
    // var res = json.decode(response.body);

    // print(res);
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
                    UserConfig()));
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
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: ColorTheme.m_white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8, 10, 8),
                child: Form(
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
                      SizedBox(height: 20),
                      mytextField(
                          kybType: TextInputType.text,
                          contro: fname,
                          // value: widget.fname,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Norman",
                          hintLebel: "First Name",
                          validateText: "Fill in your first name",
                          finalvalidateText: "Invalid Name Format",
                          icodata: Icons.person,
                          // inputFormatter: [
                          //   FilteringTextInputFormatter.allow(
                          //       new RegExp('[a-zA-Z]'))
                          // ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                      mytextField(
                          // value: widget.lname,
                          kybType: TextInputType.text,
                          contro: lname,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Mush",
                          hintLebel: "Last Name",
                          validateText: "Fill in your last name",
                          finalvalidateText: "Invalid Name Format",
                          icodata: Icons.person,
                          // inputFormatter: [
                          //   FilteringTextInputFormatter.allow(
                          //       new RegExp('[a-zA-Z]'))
                          // ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      mytextField(
                          // value: widget.phone,
                          kybType: TextInputType.phone,
                          contro: uname,
                          prex: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                color: ColorTheme.m_blue_mpauko_zaidi,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("+255 "),
                                )),
                          ),
                          maxlength: 9,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 7645...",
                          hintLebel: "Phone",
                          numbererrotxt: "Invalid Length",
                          validateText: "Fill in your valid phone number",
                          finalvalidateText: "Invalid phone no Format",
                          icodata: Icons.phone,
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(RegExp(r"\s"))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),

                      // mytextField(
                      //     contro: email,
                      //     autoval: AutovalidateMode.onUserInteraction,
                      //     hint: "Ex: example@example.com",
                      //     hintLebel: "Email",
                      //     validateText: "Fill in your email",
                      //     finalvalidateText: "Invalid Email Format",
                      //     icodata: Icons.email,
                      //     inputFormatter: [
                      //       FilteringTextInputFormatter.deny(
                      //           new RegExp(r"\s\b|\b\s"))
                      //     ],
                      //     regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"
                      //     // regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      //     //     "\\@" +
                      //     //     "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                      //     //     "(" +
                      //     //     "\\." +
                      //     //     "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                      //     //     ")+"

                      //     ),
                      // mytextField(
                      //     contro: pass,
                      //     autoval: AutovalidateMode.onUserInteraction,
                      //     hint: "Ex: *****",
                      //     hintLebel: "Password",
                      //     validateText: "Fill in your password number",
                      //     finalvalidateText: "Invalid Password Format",
                      //     icodata: Icons.password,
                      //     inputFormatter: [
                      //       FilteringTextInputFormatter.deny(
                      //           new RegExp(r"\s\b|\b\s"))
                      //     ],
                      //     regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      //         "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machafuapp/Admin/Pages/Income/Income.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:machafuapp/Admin/Shared/loading.dart';
import 'package:machafuapp/Admin/consts/sharedPrefsInitiations.dart';

import '../Admin/Models/sqlite/tokenModel.dart';
import '../Admin/consts/colorTheme.dart';

class SingIn extends StatefulWidget {
   String? accesTok;
  SingIn({this.accesTok, Key? key}) : super(key: key);

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  bool loading = false;
  bool _obscureText = true;
  //firebase
  late String email, password, msg;

  late String boolAsString;

  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  bool saveAttempt = false;

  //TextControllers
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  final formkey = GlobalKey<FormState>();

 

  bool success = false;
  void clearText() {
    user.clear();
    pass.clear();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() async {
    final response = await http.post(
        Uri.parse("https://tona-production.up.railway.app/auth/jwt/create/"),
        body: {
          "phone_number": "+255${user.text}",
          "password": pass.text,
        });
    var res = json.decode(response.body);

    print(res);

    // print(res['detail']);

    //  print(res['access']);

    if (res['detail'] == "No active account found with the given credentials") {
      await showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
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
                            child: Text("Sorry! ,Invalid credentials"),
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
                                    'Try Again',
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
                                  success = false;
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
    } else {
      setState(() {
        success = false;
      });
setState(() {
  widget.accesTok = res['access'];
});
      
      await addAccessToken(res['access']);
      await addRefreshToken(res['refresh']);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainView(Axtok: widget.accesTok!,)),
        (Route<dynamic> route) => false,
      );
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => MainView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.5,
                      1.0,
                    ],
                    colors: [
                      Color(0xFFFFFFFF),
                      ColorTheme.m_blue
                      //
                    ]),
              ),
              child: Form(
                key: formkey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      // CircleAvatar(
                      //     // backgroundImage: ExactAssetImage('assets/images/image1'),
                      //     backgroundColor: Color(0xFFFFFFFF),
                      //     radius: 50.0,
                      //     child: IconButton(
                      //       icon: Image.asset('lib/Assets/applogo.png'),
                      //       onPressed: () {},
                      //     )),
                      Stack(children: <Widget>[
                        // Text(
                        //   'SignIN',
                        //   style: TextStyle(
                        //     fontSize: 30,
                        //     foreground: Paint()
                        //       ..style = PaintingStyle.stroke
                        //       ..strokeWidth = 6
                        //       ..color = ColorTheme.m_blue_mpauko,
                        //   ),
                        // ),
                        // Solid text as fill.
                        Text('TONA', style: kBigHeading1TextStyle),
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return "Phone required";
                              }
                              RegExp regExp = new RegExp(r'^[0-9]+$');
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid phone format";
                            },

                            //   String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                            //       "\\@" +
                            //       "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                            //       "(" +
                            //       "\\." +
                            //       "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                            //       ")+";

                            //   RegExp regExp = new RegExp(p);

                            //   if (regExp.hasMatch(emailValue)) {
                            //     return null;
                            //   }

                            //   return 'Invalid Email Format';
                            // },
                            controller: user,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  new RegExp(r"\s\b|\b\s"))
                            ],
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: ColorTheme.m_blue,
                              ),
                              labelText: 'Phone',
                              labelStyle: kInfoRegularTextStyle,
                              focusColor: ColorTheme.m_blue,
                              // prefixIconColor: ColorTheme.m_blue,
                              prefix: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 5, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: ColorTheme.m_blue_mpauko_zaidi,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "+255 ",
                                          style: kInfoRegularTextStyle,
                                        ),
                                      )),
                                ),
                              ),
                              hintText: 'Ex: 764...',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: Validators.compose([
                              Validators.required('Password required'),
                              // Validators.patternString(
                              //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                              //     'Invalif format')
                            ]),
                            obscureText: _obscureText,
                            controller: pass,
                            cursorColor: Colors.green[400],
                            decoration: InputDecoration(
                              helperText: "Usiruhusu mtu kuona taarifa hizi.",

                              prefixIcon: Icon(
                                Icons.security_rounded,
                                color: ColorTheme.m_blue,
                              ),
                              labelText: 'Password',
                              // prefixIconColor: ColorTheme.m_blue,
                              labelStyle: kInfoRegularTextStyle,
                              suffix: GestureDetector(
                                onTap: (() => _toggle()),
                                child: _obscureText
                                    ? Icon(
                                        Icons.visibility,
                                        color: ColorTheme.m_blue,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: ColorTheme.m_blue,
                                      ),
                              ),
                              hintText: 'Enter Password',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                            ),
                          ),
                        ),
                      ),
                      // new TextButton(
                      //     onPressed: _toggle,
                      //     child: new Text(
                      //       _obscureText ? "Show Password" : "Hide Password",
                      //       style: TextStyle(color: Colors.black),
                      //     )),
                      success == true
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  saveAttempt = true;
                                });

                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();

                                  _login();
                                  setState(() {
                                    success = true;
                                    // successErr = true;
                                  });
                                }
                              },
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: ColorTheme.m_blue,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 25.0),
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login',
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

                                  if (formkey.currentState!.validate()) {
                                    formkey.currentState!.save();

                                    _login();
                                    setState(() {
                                      success = true;
                                      // successErr = true;
                                    });
                                  }

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => MainView()));

                                  // _saveDeviceToken();

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => Manager()));
                                },
                              )),

                      // ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => MainView()));
                      //     },
                      //     child: Text("ingia"))
                    ],
                  ),
                ),
              ),
            ),
          ));
  }
}

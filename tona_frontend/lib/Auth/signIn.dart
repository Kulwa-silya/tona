import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machafuapp/Admin/Pages/Income/Income.dart';
import 'package:machafuapp/Admin/Pages/dashboard.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:machafuapp/Admin/Shared/loading.dart';
import 'package:machafuapp/Admin/consts/sharedPrefsInitiations.dart';

import '../Admin/Models/sqlite/tokenModel.dart';
import '../Admin/consts/colorTheme.dart';

class SingIn extends StatefulWidget {
  SingIn({Key? key}) : super(key: key);

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

  String? accesTok;
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
        Uri.parse("https://tona-production-8953.up.railway.app/auth/jwt/create/"),
        body: {
          "phone_number": user.text,
          "password": pass.text,
        });
    var res = json.decode(response.body);

    print(res);

    // print(res['detail']);

    //  print(res['access']);

    if (res['detail'] == "No active account found with the given credentials") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Income()));

      // if (res[0]['role'] == 'admin') {
      //   setState(() => loading = true);
      //   // print(datauser);
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => DashBoard(

      //               )));
      // } else if (res[0]['role'] == 'sales') {
      //   Navigator.pushReplacementNamed(context, '/Driver');
      // } else if (datauser2[0]['role'] == 'delivery') {
      //   Navigator.pushReplacementNamed(context, '/Officer');
      // }
      setState(() {});
    } else {
     await addAccessToken(res['access']);
      await addRefreshToken(res['refresh']);

      // setState(() {
      //    DatabaseHelper.instance.add(Tokening(
      //                                                                           accesstok: res['access'],
      //                                                                           refreshtok: res['refresh'])
      //                                                                         );
      //                                                                       });
    }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainView()));

     
    
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
                        Text(
                          'TONA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: ColorTheme.m_blue,
                          ),
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: TextFormField(
                          // onChanged: (textVal) {
                          //   setState(() {
                          //     email = textVal;
                          //   });
                          // },
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: (emailValue) {
                          //   if (emailValue!.isEmpty) {
                          //     return "Fill in your email";
                          //   }

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
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Email',
                            hintText: 'Ex: example@example.com',
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
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 16.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            prefixIcon: Icon(Icons.security_rounded),
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.black),
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
                      ),
                      new TextButton(
                          onPressed: _toggle,
                          child: new Text(
                            _obscureText ? "Show Password" : "Hide Password",
                            style: TextStyle(color: Colors.black),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 60.0, vertical: 25.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
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

                                _login();
                              }

                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => MainView()));

                              // _saveDeviceToken();

                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => Manager()));
                            },
                          )),

                          ElevatedButton(onPressed: (){
                             Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainView()));
                          }, child: Text("ingia"))
                    ],
                  ),
                ),
              ),
            ),
          ));
  }
}

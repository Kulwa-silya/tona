import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:machafuapp/Auth/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? accesTok = "null";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TONA Trading',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? accesTok;

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue;
    });
    return stringValue;
  }

  @override
  void initState() {
    getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icon(Icons.holiday_village),
      nextScreen: accesTok == null ? SingIn() : MainView(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 500,
      splashIconSize: 500,
    );
  }
}

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String? accesTok;

  bool _inactive = false;

  Timer? _timer;

  Future<void> deletePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('accesstoken');
    prefs.remove('refreshtoken');
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(seconds: 3), _logOut);

    if (_inactive) {
      setState(() {
        _inactive = false;
        deletePreference();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SingIn()),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  void _logOut() {
    setState(() {
      _inactive = true;
    });
    // Perform the logout action here
  }

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue;

      print("global accesstok $accesTok");
    });
    return stringValue;
  }

  @override
  void initState() {
    _resetTimer();
    getAccessToken();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

//   Future<void> deletePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove('accesstoken');
//     prefs.remove('refreshtoken');
//   }

// //check and logout
//   void _resetTimer() {
//     Timer _timer = Timer(Duration(seconds: 3), _logOut);

//     if (_inactive) {
//       setState(() {
//         _inactive = false;
//         deletePreference();
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => SingIn()),
//           (Route<dynamic> route) => false,
//         );
//       });
//     }
//     // _timer.cancel();
//     _timer = Timer(Duration(seconds: 3), _logOut);
//   }

//   void _logOut() {
//     setState(() {
//       _inactive = true;
//     });
//     // Perform the logout action here
//   }

//   Future getAccessToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? stringValue = prefs.getString('accesstoken');
//     setState(() {
//       accesTok = stringValue;
//     });
//     return stringValue;
//   }

//   @override
//   void initState() {
//     _resetTimer();
//     getAccessToken();
//     WidgetsBinding.instance!.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance!.removeObserver(this);
//     super.dispose();
//   }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is being suspended (e.g., minimized, pushed to background)
      // Clear shared preferences here
      clearSharedPreferences();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icon(Icons.holiday_village),
      // nextScreen: accesTok == null
      //     ? SingIn(
      //         accesTok: accesTok,
      //       )
      //     : MainView(
      //         Axtok: accesTok!,
      //       ),
      nextScreen: SingIn(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 500,
      splashIconSize: 500,
    );
  }
}

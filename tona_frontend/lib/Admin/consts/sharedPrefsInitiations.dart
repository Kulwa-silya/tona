


import 'package:shared_preferences/shared_preferences.dart';



 addAccessToken(String tok) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accesstoken', tok);
  }

  addRefreshToken(String tok) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refreshtoken', tok);
  }


  


  
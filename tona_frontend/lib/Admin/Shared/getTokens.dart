import 'package:shared_preferences/shared_preferences.dart';

getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');


    return stringValue;
  }
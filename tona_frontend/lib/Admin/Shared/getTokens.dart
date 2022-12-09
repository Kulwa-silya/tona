import 'package:shared_preferences/shared_preferences.dart';




class Token{
  String? accsstok;
getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('accesstoken');
 
  return stringValue;
}
}
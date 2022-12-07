import 'package:shared_preferences/shared_preferences.dart';

String? accsstok;
getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('accesstoken');
  print(stringValue);
  return stringValue;
}

  import 'package:shared_preferences/shared_preferences.dart';


class GettingToken{

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    return stringValue;
  }
}
// _fetchList() {
//   return _prefs.getStringList('key');
// }



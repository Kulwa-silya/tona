import 'dart:io';
import 'package:http/http.dart' as http;

class UserProvider {
  // String? axtok;
  // UserProvider({this.axtok});
  Future fetchInfoe(String acctok) async {
    final response = await http.get(
        Uri.parse('https://tona-production-8ea1.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT $acctok",
        });

    return response;
  }
}

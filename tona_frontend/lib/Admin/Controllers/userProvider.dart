import 'dart:io';
import 'package:http/http.dart' as http;

class UserProvider {
  // String? axtok;
  // UserProvider({this.axtok});
  Future fetchInfoe() async {
    final response = await http.get(
        Uri.parse('https://tona-production-8ea1.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc4MzY5ODQ0LCJqdGkiOiI3MzlmODE0ZDViNTQ0NzNkOTk4ZjVlMjczMDg3ZmM4ZCIsInVzZXJfaWQiOjF9.B6LcScIH-pFoIVfg56jHJsanWOjgMnWNAH85PtCNoyQ",
        });

    return response;
  }
}

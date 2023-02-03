import 'dart:io';
import 'package:http/http.dart' as http;

class UserProvider {
  String? axtok;
  UserProvider({this.axtok});
  Future fetchInfoe() async {
    final response = await http.get(
        Uri.parse('https://tona-production-8ea1.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc1NjgwODU2LCJqdGkiOiI1YWFmYjhjMjY4MTg0NGVkYmNhZjU4MTBmNWE5NWZlNiIsInVzZXJfaWQiOjF9.dQCKIj0y5QscYvbzBZG8TZVfJ1dL_rGOIzprcbNtwi4",
        });

    return response;
  }
}

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
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc4NzA5MzMxLCJqdGkiOiI3ZGNiMGFiZDJmN2Q0ODYxYTMyMzc0ZjA0MTM0M2E0YiIsInVzZXJfaWQiOjF9.19w55yQrBozrTpz0KArkkTg7xcW2eY_Y6BuW2RCI5Jc",
        });

    return response;
  }
}

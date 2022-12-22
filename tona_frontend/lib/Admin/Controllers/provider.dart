import 'dart:io';
import 'package:http/http.dart' as http;

class UserProvider {
  Future fetchInfoe() async {
    final response = await http.get(
        Uri.parse('https://tona-production.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjcxMTM3OTU2LCJqdGkiOiI2OGVlMGVlNGEzYjA0OGM1OTBhNDc2NTc3MWQ5YmZiOSIsInVzZXJfaWQiOjF9.K_mOW_mdjND5GSAroPW2J0W_7sOjZr8UzsnOtiqAWJ4",
        });

    return response;
  }
}

import 'dart:io';
import 'package:http/http.dart' as http;

class UserProvider{

  Future fetchInfoe() async {

    final response = await http.get(
        Uri.parse('https://tona-production.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader: "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjcwODQ5MjI1LCJqdGkiOiI4MGM5MzY1MjI2ZGQ0ZTI0YTdmNjAzZDI5YzZlNmJjNSIsInVzZXJfaWQiOjF9.wlwN10elGY7R6eJmq8pBC5DfrDeg3cxH95egocT9ye0",
        });

    return response;
  }
}
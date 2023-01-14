import 'dart:io';
import 'package:http/http.dart' as http;

class UserProvider {
  Future fetchInfoe() async {
    final response = await http.get(
        Uri.parse('https://tona-production-8953.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjczOTc5NjE3LCJqdGkiOiJjZTFhZTBjYmQ1M2E0ZGVhODc3NGI1ZmYwN2UzMmZkZiIsInVzZXJfaWQiOjF9.KcJyRuZcGQKuaQCE86BRVtQyXxbSbPq1o6FMcCAwY-4",
        });

    return response;
  }
}

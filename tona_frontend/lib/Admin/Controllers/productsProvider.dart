import 'package:http/http.dart' as http;
import 'dart:io';

class ProductProvider {

  Future fetchProducts() async {
    final response = await http.get(
        Uri.parse('https://tona-production-8953.up.railway.app/store/products/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjczMjcxODUxLCJqdGkiOiI0MDI5NDdhZjkyYTQ0NTEzODZmZWE0ZjczZmUyNmJjMyIsInVzZXJfaWQiOjF9.r-jbFm3mTIhuNMYfH0MWtK7Ca75TPSIC0oxcy3wx0V0",
        });

    return response;
  }
}
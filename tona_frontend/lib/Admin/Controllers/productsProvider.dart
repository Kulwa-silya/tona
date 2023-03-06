import 'package:http/http.dart' as http;
import 'dart:io';

class ProductProvider {

  Future fetchProducts() async {
    final response = await http.get(
        Uri.parse('https://tona-production-8ea1.up.railway.app/store/products/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc2MDIzMTk5LCJqdGkiOiIyNjU4YzY0YmM0YjE0MmM4OWNkOGU2N2RkZjNjMzM1YyIsInVzZXJfaWQiOjF9.RpxfnWVB6jdXgR4M1AFEsDDs_9k6kgB6g-fa7vYAnI0",
        });

    return response;
  }
}
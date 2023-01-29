import 'package:http/http.dart' as http;
import 'dart:io';

class ProductProvider {

  Future fetchProducts() async {
    final response = await http.get(
        Uri.parse('https://tona-production-8ea1.up.railway.app/store/products/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc1MjQ5ODcyLCJqdGkiOiIyMDk0YjI5NzM3YTY0ZGEwYmZhMjJhNDcwNTlhMjMzNCIsInVzZXJfaWQiOjF9.UjIRODdJ8ElUjoPjYBPjJ_gRIGKkDNwUQdNTRbQFofM",
        });

    return response;
  }
}
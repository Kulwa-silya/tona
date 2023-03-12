import 'package:http/http.dart' as http;
import 'dart:io';

class ProductProvider {

  Future fetchProducts(int id,String acctok) async {
    final response = await http.get(
        Uri.parse('https://tona-production-8ea1.up.railway.app/store/products/?collection_id=$id'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT $acctok",
        });

    return response;
  }
}
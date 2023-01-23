import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:http/http.dart' as http;
import '../../Controllers/productsProvider.dart';
import '../../Controllers/userProvider.dart';
import '../../Models/getProducts.dart';
import '../../consts/colorTheme.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ProductProvider productProvider = ProductProvider();

  List products = [];

  var isloading = false;

  // final productList;

  fetchProducts() async {
    http.Response res = await productProvider.fetchProducts();

    setState(() {
      // productList = productsFromJson(res.body);

      products = productsFromJson(res.body);

      //  products =  productList?.map((dynamic item) => productsFromJson(item)).toList() ?? [];
      // products.results![0]!.title;
// extractedData.myChannels[0].name
// extractedData.myChannels[0].imageUrl

      // for (var ch in productList.results!) {
      //   print(ch!.title);
      // print(ch.name);
      // print(ch.imageUrl);
      // }
      // print(productList);
      // return productList;
    });

    print(products);
  }

  // Future fetchProducts1() async {
  //   final response = await http.get(
  //       Uri.parse(
  // 'https://tona-production-8953.up.railway.app/store/products/'),
  //       headers: {
  //         HttpHeaders.authorizationHeader:
  //             "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjczOTc5NjE3LCJqdGkiOiJjZTFhZTBjYmQ1M2E0ZGVhODc3NGI1ZmYwN2UzMmZkZiIsInVzZXJfaWQiOjF9.KcJyRuZcGQKuaQCE86BRVtQyXxbSbPq1o6FMcCAwY-4",
  //       });

  //   List dat = json.decode(response.body);
  //   return dat;
  // }

  void initState() {
    setState(() {
      isloading = true;
      fetchProducts();
      // fetchProducts1();
      isloading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              // Navigator.pushReplacementNamed(context, '/dash');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainView()),
                (Route<dynamic> route) => false,
              );
              // Navigator.of(context)
              //     .pushNamedAndRemoveUntil('/dash', (route) => false);
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => DashBoard()));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      color: ColorTheme.m_blue,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 10,
                          color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                        ),
                      ))),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Addproduct()));
                },
                child: Center(
                  child: Text(
                    "New Product",
                    style: TextStyle(
                        color: ColorTheme.m_blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: ColorTheme.m_white,
        ),
        body: FutureBuilder(
            // future: fetchProducts1(),
            builder: (ctx, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (cnxt, index) {
                return Container(
                  child: Center(child: Text(snapshot.data[3].toString())),
                  // child: snapshot.data[3].map(
                  //     (e) {
                  //       return Column(
                  //         children: [
                  //           Text(e)
                  //         ],
                  //       );
                  //     },
                  //   ),
                );
              });
        })
        // Container(
        //     color: ColorTheme.m_white,
        //     child: isloading == false
        //         ? Column(
        //             children: [
        //               ...productList.map(
        //                 (e) {
        //                   return Column(
        //                     children: [
        //                       Text(e.results.title),
        //                     ],
        //                   );
        //                 },
        //               )
        //             ],
        //           )
        //         : Center(
        //             child: CircularProgressIndicator(),
        //           )),
        );
  }
}

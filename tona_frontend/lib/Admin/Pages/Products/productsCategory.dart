import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Shared/backarrow.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProductCat extends StatefulWidget {
  const ProductCat({Key? key}) : super(key: key);

  @override
  State<ProductCat> createState() => _ProductCatState();
}

class _ProductCatState extends State<ProductCat> {
  List<dynamic> jsondat = [];
  fetchProductsCategory() async {
    final response = await http.get(
        Uri.parse(
            'https://tona-production-8ea1.up.railway.app/store/collections/'),
        headers: {
          HttpHeaders.authorizationHeader:
              "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc4MzY5ODQ0LCJqdGkiOiI3MzlmODE0ZDViNTQ0NzNkOTk4ZjVlMjczMDg3ZmM4ZCIsInVzZXJfaWQiOjF9.B6LcScIH-pFoIVfg56jHJsanWOjgMnWNAH85PtCNoyQ",
        });
    jsondat = jsonDecode(response.body);
    print(jsondat);
    return jsondat;
  }

  @override
  void initState() {
    fetchProductsCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.m_white,
      appBar: AppBar(
        backgroundColor: ColorTheme.m_white,
        elevation: 0,
        leading: backArrow(towhere: MainView()),
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
                  "New Collection",
                  style: TextStyle(
                      color: ColorTheme.m_blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: fetchProductsCategory(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: ColorTheme.m_blue,
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int i) {
                    if (jsondat.isEmpty) {
                      return CircularProgressIndicator(
                        strokeWidth: 1,
                        color: ColorTheme.m_blue,
                      );
                    } else {
                      final data = jsondat[i];
                      int pid = data['id'];
                      String title = data['title'];
                      int count = data['products_count'];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                        child: GestureDetector(
                            onTap: (() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Products(
                                        id: pid,
                                        title: title,
                                      )));
                            }),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(17),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                              color: ColorTheme.m_blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(count.toString()),
                                      ],
                                    )))),
                      );
                    }
                  });
            }
          }),
    );
  }
}

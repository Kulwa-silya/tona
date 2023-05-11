import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Products/Addcollection.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/productViewer.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Shared/backarrow.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ProductCat extends StatefulWidget {
  ProductCat({required this.Axtok, Key? key}) : super(key: key);

  String Axtok;

  @override
  State<ProductCat> createState() => _ProductCatState();
}

class _ProductCatState extends State<ProductCat> {
  List<dynamic> jsondat = [];

  // String? accesTok;

  bool showsearchResult = false;
  bool collectionoffstg = false;

  String? searchValue;

  var jsonsearchData;

  var data;

  var titleG, pidG, countG;

  TextEditingController searchController = new TextEditingController();

  fetchProductsCategory() async {
    final response = await http.get(
      Uri.parse('https://tona-production.up.railway.app/store/collections/'),
    );
    jsondat = jsonDecode(response.body);
    print(jsondat);
    return jsondat;
  }

  searchProducts() async {
    final response = await http.get(
      Uri.parse(
          'https://tona-production.up.railway.app/store/products/?search=$searchValue'),
    );
    jsonsearchData = jsonDecode(response.body);
    print(jsondat[0]['results']);
    return jsonsearchData['results'];
  }

  @override
  void initState() {
    fetchProductsCategory();

    // fetchProductsCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.m_white,
      appBar: AppBar(
        backgroundColor: ColorTheme.m_white,
        elevation: 0,
        leading: backArrow(towhere: MainView(Axtok: widget.Axtok,)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddCollection(
                          hideBack: false,
                        )));
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
          builder: (context, AsyncSnapshot snapsht) {
            if (!snapsht.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: ColorTheme.m_blue,
                ),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        height: 55,
                        color: ColorTheme.m_white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchValue = value;
                                searchProducts();
                              });
                            },
                            onTap: () {
                              setState(() {
                                showsearchResult = true;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Search Product',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w300),
                              suffixIcon: GestureDetector(
                                // onTap: () {
                                //   searchProducts();
                                // },
                                child: Icon(
                                  Icons.search,
                                  color: ColorTheme.m_blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: ColorTheme.m_blue,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorTheme.m_blue),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  showsearchResult == true
                      ? Expanded(
                          child: FutureBuilder(
                              future: searchProducts(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("Loading Please wait");
                                } else {
                                  if (snapshot.data.length <= 0) {
                                    return Text(
                                      searchController.text.isEmpty
                                          ? "Insert your query"
                                          : "No such product",
                                      style: kBodyTextStyle,
                                    );
                                  }
                                  return Container(
                                    height: 200,
                                    color: ColorTheme.m_white,
                                    child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (cnt, i) {
                                          String pname =
                                              snapshot.data[i]['title'];
                                          String img;
                                          int imgId;
                                          try {
                                            img = snapshot.data[i]["images"][0]
                                                ["image"];
                                          } catch (e) {
                                            img = "assets/images/image_1.png";
                                            imgId = 0;
                                          }

                                          return Builder(builder: (context) {
                                            return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Viewer(
                                                                image: img,
                                                                title: snapshot
                                                                        .data[i]
                                                                    ['title'],
                                                                    axtok: widget.Axtok,
                                                                collId: pidG,
                                                                tit: titleG,
                                                                inventory: snapshot
                                                                        .data[i]
                                                                    [
                                                                    'inventory'],
                                                                desc: snapshot
                                                                        .data[i]
                                                                    [
                                                                    'description'],
                                                                uprice: snapshot
                                                                    .data[i][
                                                                        'unit_price']
                                                                    .toString(),
                                                              )));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0, 4, 16, 4),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: Container(
                                                        color: ColorTheme
                                                            .m_blue_mpauko_zaidi_zaidi,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            9),
                                                                child: Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child: myImageView(
                                                                        img:
                                                                            img)),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                pname,
                                                                style:
                                                                    kBodyRegularTextStyle,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ));
                                          });
                                        }),
                                  );
                                }
                              }),
                        )
                      :
                      // SizedBox.shrink(),
                      Expanded(
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapsht.data.length,
                              itemBuilder: (context, int i) {
                                if (jsondat.isEmpty) {
                                  return CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: ColorTheme.m_blue,
                                  );
                                } else {
                                  data = jsondat[i];
                                  // pid = data['id'];
                                  // title = data['title'];
                                  // count = data['products_count'];
                                  int pid = data['id'];
                                  String title = data['title'];
                                  int count = data['products_count'];

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 8, 16, 8),
                                    child: GestureDetector(
                                        onTap: (() {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Products(
                                                        id: pid,
                                                        title: title,
                                                        Axxtok: widget.Axtok,
                                                      )));
                                        }),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 100,
                                                color: ColorTheme
                                                    .m_blue_mpauko_zaidi_zaidi,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      title,
                                                      style: TextStyle(
                                                          color:
                                                              ColorTheme.m_blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(count.toString()),
                                                  ],
                                                )))),
                                  );
                                }
                              }),
                        ),
                ],
              );
            }
          }),
    );
  }
}

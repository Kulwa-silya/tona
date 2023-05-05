import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/productViewer.dart';
import 'package:machafuapp/Admin/Pages/Products/productsCategory.dart';
import 'package:machafuapp/Admin/Shared/myDeleteDialog.dart';
import 'package:machafuapp/Admin/Shared/myEditorDialog.dart';
import 'package:machafuapp/Admin/Shared/searcher.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/productsProvider.dart';
import '../../Models/getProducts.dart';
import '../../Shared/backarrow.dart';
import '../../consts/colorTheme.dart';
import '../../ui/shared/loading.dart';

class Products extends StatefulWidget {
  int? id;
  String? title;
  Products({this.id, this.title, Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ProductProvider productProvider = ProductProvider();

  List productList = [];
  List? productImage = [];

  var isloading = false;

  final formkey = GlobalKey<FormState>();

  bool saveAttempt = false;
  int? ide;

  String? titlee;

  TextEditingController ptitle = new TextEditingController();
  TextEditingController pDesc = new TextEditingController();
  TextEditingController searchController = new TextEditingController();

  List _foundProducts = [];

  String? accesTok;

  bool showsearchResult = false;

  var jsonsearchData;
  List<dynamic> jsondat = [];

  String? searchValue;

  getProducts() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String accTok = pre.getString("accesstoken") ?? "";

// int age = pre.getInt("age") ?? 0;
// bool married = pre.getBool("married") ?? false;
// double price = pre.getDouble("price") ?? 0.00;
// List<String> tags = pre.getStringList("tags") ?? [];
  }

  fetchProducts() async {
    http.Response res =
        await productProvider.fetchProducts(widget.id!, accesTok!);

    setState(() {
      final proddata = ProductsAll.fromJson(json.decode(res.body));
      isloading = false;
      productList = proddata.results;

      // final picha = Result.fromJson(json.decode(res.body));
      // productImage = picha.images;
      isloading = true;

      // print(picha.);

      // for (var ch in proddata.results) {
      //   titlee = ch.title;
      //   ide = ch.id;
      //   print(ch.id);
      //   print(ch.title);
      //   print(ch.priceWithTax.toString());
      // }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // isloading = false;
    super.dispose();
  }

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });

    print(" tokeni $accesTok");
    return stringValue;
  }

//seachspecific products in a certain collection
  searchspeProducts() async {
    final response = await http.get(
      Uri.parse(
          "https://tona-production.up.railway.app/store/products/?collection_id=${widget.id}&search=$searchValue"),
    );
    jsonsearchData = jsonDecode(response.body);
    // print(jsonsearchData[0]['results']);
    return jsonsearchData['results'];
  }

  void initState() {
    setState(() {
      getAccessToken().then((value) {
        isloading = true;
        fetchProducts();
        isloading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backArrow(
            towhere: ProductCat(
          Axtok: accesTok!,
        )),
        title: Text(
          widget.title.toString(),
          style: TextStyle(color: ColorTheme.m_blue),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: TheSearcher());
              },
              icon: Icon(
                Icons.search,
                color: ColorTheme.m_blue,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Addproduct(pid: widget.id, titl: widget.title)));
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
      body: Column(
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
                        searchspeProducts();
                      });
                    },
                    onTap: () {
                      setState(() {
                        showsearchResult = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search ${widget.title}',
                      labelStyle: TextStyle(fontWeight: FontWeight.w300),
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
                        borderSide: BorderSide(color: ColorTheme.m_blue),
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
                      future: searchspeProducts(),
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
                                  String pname = snapshot.data[i]['title'];
                                  String img;
                                  int imgId;
                                  try {
                                    img =
                                        snapshot.data[i]["images"][0]["image"];
                                  } catch (e) {
                                    img = "assets/images/image_1.png";
                                    imgId = 0;
                                  }

                                  return Builder(builder: (context) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => Viewer(
                                                        image: img,
                                                        title: snapshot.data[i]
                                                            ['title'],
                                                        collId: 12,
                                                        tit: "tit",
                                                        inventory:
                                                            snapshot.data[i]
                                                                ['inventory'],
                                                        desc: snapshot.data[i]
                                                            ['description'],
                                                        uprice: snapshot.data[i]
                                                                ['unit_price']
                                                            .toString(),
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 4, 16, 4),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            child: Container(
                                                color: ColorTheme
                                                    .m_blue_mpauko_zaidi_zaidi,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9),
                                                        child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            child: myImageView(
                                                                img: img)),
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
              : Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: ColorTheme.m_white,
                      child: isloading == true
                          ? SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ...productList.map(
                                    (e) {
                                      String img;
                                      int imgId;
                                      try {
                                        img = e.images[0].image;
                                        imgId = e.images[0].id;
                                      } catch (e) {
                                        img = "assets/images/image_1.png";
                                        imgId = 0;
                                      }

                                      return
                                          // _foundProducts.isNotEmpty
                                          //     ?

                                          Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8, 16, 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Viewer(
                                                              image: img,
                                                              title: e.title,
                                                              collId: widget.id,
                                                              tit: widget.title,
                                                              inventory:
                                                                  e.inventory,
                                                              desc:
                                                                  e.description,
                                                              uprice: e
                                                                  .unitPrice)));
                                            },
                                            child: Container(
                                              color: ColorTheme
                                                  .m_blue_mpauko_zaidi_zaidi,
                                              child: ListTile(
                                                leading: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Builder(
                                                        builder: (context) {
                                                      try {
                                                        return Image.network(
                                                          e.images[0].image,
                                                        );
                                                      } catch (e) {
                                                        return Image.asset(
                                                            'assets/images/image_1.png');
                                                      }
                                                    }),

                                                    // FadeInImage(
                                                    //    image:  placeholder: null,),
                                                    color: ColorTheme.m_blue),
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 2),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        e.title,
                                                        style: TextStyle(
                                                            color: ColorTheme
                                                                .m_blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "(${e.inventory})",
                                                        style: TextStyle(
                                                            color: ColorTheme
                                                                .m_blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 1, 8, 8),
                                                      child: Text(
                                                        e.description,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      e.unitPrice + " TZs ",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                myEditordialog(
                                                              islod: isloading,
                                                              widget:
                                                                  "addproduct",
                                                              heading:
                                                                  "Product Editor",
                                                              data1: e.title,
                                                              data2:
                                                                  e.description,
                                                              data3: e.inventory
                                                                  .toString(),
                                                              whatpart:
                                                                  "product",
                                                              data4:
                                                                  e.unitPrice,
                                                              data5: e
                                                                  .collection
                                                                  .toString(),
                                                              accesstok:
                                                                  accesTok,
                                                              image: img,
                                                              imageId: imgId,
                                                              id: e.id,
                                                              collId: widget.id,
                                                              collname:
                                                                  widget.title,
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color:
                                                              ColorTheme.m_blue,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  myDeletedialog(
                                                                    pid: e.id,
                                                                    email:
                                                                        "null",
                                                                    tit:
                                                                        e.title,
                                                                    whatpart:
                                                                        "product",
                                                                    collId:
                                                                        widget
                                                                            .id,
                                                                    collname:
                                                                        widget
                                                                            .title,
                                                                  ));
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color:
                                                              ColorTheme.m_red,
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      // : Text("no data");
                                    },
                                  )
                                ],
                              ),
                            )
                          : Center(
                              child: circularLoader(),
                            )),
                ),
        ],
      ),
    );
  }
}

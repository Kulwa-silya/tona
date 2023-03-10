import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/productsCategory.dart';
import 'package:machafuapp/Admin/Shared/myDeleteDialog.dart';
import 'package:machafuapp/Admin/Shared/myEditorDialog.dart';
import 'package:machafuapp/Admin/Shared/searcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/productsProvider.dart';
import '../../Models/getProducts.dart';
import '../../Shared/backarrow.dart';
import '../../consts/colorTheme.dart';

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

  List _foundProducts = [];

  getProducts() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String accTok = pre.getString("accesstoken") ?? "";

// int age = pre.getInt("age") ?? 0;
// bool married = pre.getBool("married") ?? false;
// double price = pre.getDouble("price") ?? 0.00;
// List<String> tags = pre.getStringList("tags") ?? [];
  }

  fetchProducts() async {
    http.Response res = await productProvider.fetchProducts(widget.id!);

    setState(() {
      final proddata = ProductsAll.fromJson(json.decode(res.body));
      isloading = true;
      productList = proddata.results;

      // final picha = Result.fromJson(json.decode(res.body));
      // productImage = picha.images;
      isloading = false;

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
    isloading = false;
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = productList;
    } else {
      results = productList
          .where((prod) =>
              prod.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      isloading = true;
      _foundProducts = results;
      isloading = false;
    });
  }

  void initState() {
    setState(() {
      isloading = true;
      fetchProducts();

      isloading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backArrow(towhere: ProductCat()),
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
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) =>
                //         Addproduct(pid: widget.id, titl: widget.title)));
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
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(fontWeight: FontWeight.w300),
                      suffixIcon: Icon(
                        Icons.search,
                        color: ColorTheme.m_blue,
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
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: ColorTheme.m_white,
                child: isloading == false
                    ? SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ...productList.map(
                              (e) {
                                return
                                    // _foundProducts.isNotEmpty
                                    //     ?
                                    Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color:
                                          ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                      child: ListTile(
                                        leading: Container(
                                            height: 50,
                                            width: 50,
                                            child: Image.network(
                                                e.images[0].image),
                                            color: ColorTheme.m_blue),
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 2),
                                          child: Row(
                                            children: [
                                              Text(
                                                e.title,
                                                style: TextStyle(
                                                    color: ColorTheme.m_blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "(${e.inventory})",
                                                style: TextStyle(
                                                    color: ColorTheme.m_blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 1, 8, 8),
                                          child: Text(e.description),
                                        ),
                                        trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Column(
                                                children: [
                                                  Text(
                                                    e.unitPrice + " TZs ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  // Text(
                                                  //   e.priceWithTax.toString(),
                                                  //   style: TextStyle(
                                                  //       fontSize: 12,
                                                  //       fontWeight:
                                                  //           FontWeight.w300),
                                                  // ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        myEditordialog(
                                                      widget: "addproduct",
                                                      heading: "Product Editor",
                                                      data1: e.title,
                                                      data2: e.description,
                                                      data3: e.inventory
                                                          .toString(),
                                                      data4: e.unitPrice,
                                                      data5: e.collection
                                                          .toString(),
                                                      id: e.id,
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: ColorTheme.m_blue,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          myDeletedialog(
                                                            pid: e.id,
                                                            email: "null",
                                                            tit: e.title,
                                                          ));
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: ColorTheme.m_red,
                                                ),
                                              )
                                            ]),
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
                        child: CircularProgressIndicator(),
                      )),
          ),
        ],
      ),
    );
  }
}

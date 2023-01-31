import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Shared/myDeleteDialog.dart';
import 'package:machafuapp/Admin/Shared/myEditorDialog.dart';
import 'package:machafuapp/Admin/Shared/searcher.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:http/http.dart' as http;
import '../../Controllers/productsProvider.dart';
import '../../Models/getProducts.dart';
import '../../consts/colorTheme.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ProductProvider productProvider = ProductProvider();

  List productList = [];

  var isloading = false;

  final formkey = GlobalKey<FormState>();

  bool saveAttempt = false;
  int? ide;

  String? titlee;

  TextEditingController ptitle = new TextEditingController();
  TextEditingController pDesc = new TextEditingController();

  List _foundUsers = [];

  fetchProducts() async {
    http.Response res = await productProvider.fetchProducts();

    setState(() {
      final proddata = ProductsAll.fromJson(json.decode(res.body));
      isloading = true;
      productList = proddata.results;

      isloading = false;

      for (var ch in proddata.results) {
        // setState(() {
        // isloading = true;
        titlee = ch.title;
        ide = ch.id;
        // isloading = false;
        // });

        print(ch.id);
        print(ch.title);
        print(ch.priceWithTax.toString());
      }
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
          .where((user) =>
              user.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
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
      body: Column(
        children: [
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          const SizedBox(
            height: 20,
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
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color:
                                          ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 2),
                                          child: Text(
                                            e.title,
                                            style: TextStyle(
                                                color: ColorTheme.m_blue,
                                                fontWeight: FontWeight.bold),
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
                                              Text(
                                                e.unitPrice + " TZs ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        myEditordialog(
                                                      heading: "Product Editor",
                                                      data1: e.id.toString(),
                                                      data2: e.title,
                                                      data3: e.description,
                                                    ),

                                                    // builder: (_) => AlertDialog(
                                                    //       title: Column(
                                                    //         children: [
                                                    //           Text(
                                                    //               "Product Editor"),
                                                    //           Form(
                                                    //             key: formkey,
                                                    //             child: Column(
                                                    //               children: [
                                                    //                 mytextField(
                                                    //                     contro:
                                                    //                         ptitle,
                                                    //                     autoval:
                                                    //                         AutovalidateMode
                                                    //                             .onUserInteraction,
                                                    //                     hint:
                                                    //                         "Product Name",
                                                    //                     hintLebel:
                                                    //                         "${e.title}",
                                                    //                     validateText:
                                                    //                         "Fill in your product name",
                                                    //                     finalvalidateText:
                                                    //                         "Invalid Name Format",
                                                    //                     icodata: Icons
                                                    //                         .title,
                                                    //                     inputFormatter: [
                                                    //                       FilteringTextInputFormatter
                                                    //                           .allow(
                                                    //                               new RegExp('[a-zA-Z]'))
                                                    //                     ],
                                                    //                     regExpn:
                                                    //                         "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                                    //                             "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                                                    //                 mytextField(
                                                    //                     contro:
                                                    //                         pDesc,
                                                    //                     autoval:
                                                    //                         AutovalidateMode
                                                    //                             .onUserInteraction,
                                                    //                     hint:
                                                    //                         "Product Desc",
                                                    //                     hintLebel:
                                                    //                         "${e.description}",
                                                    //                     validateText:
                                                    //                         "Fill in your product name",
                                                    //                     finalvalidateText:
                                                    //                         "Invalid Name Format",
                                                    //                     icodata: Icons
                                                    //                         .description,
                                                    //                     inputFormatter: [
                                                    //                       FilteringTextInputFormatter
                                                    //                           .allow(
                                                    //                               new RegExp('[a-zA-Z]'))
                                                    //                     ],
                                                    //                     regExpn:
                                                    //                         "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                                    //                             "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                                                    //                 mytextField(
                                                    //                     contro:
                                                    //                         ptitle,
                                                    //                     autoval:
                                                    //                         AutovalidateMode
                                                    //                             .onUserInteraction,
                                                    //                     hint:
                                                    //                         "Product Unit Price",
                                                    //                     hintLebel:
                                                    //                         "${e.unitPrice}",
                                                    //                     validateText:
                                                    //                         "Fill in your product name",
                                                    //                     finalvalidateText:
                                                    //                         "Invalid Name Format",
                                                    //                     icodata: Icons
                                                    //                         .title,
                                                    //                     inputFormatter: [
                                                    //                       FilteringTextInputFormatter
                                                    //                           .allow(
                                                    //                               new RegExp('[a-zA-Z]'))
                                                    //                     ],
                                                    //                     regExpn:
                                                    //                         "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                                    //                             "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                                                    //               ],
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //       titleTextStyle: TextStyle(
                                                    //           fontWeight:
                                                    //               FontWeight.bold,
                                                    //           color: Colors.black,
                                                    //           fontSize: 20),
                                                    //       actionsOverflowButtonSpacing:
                                                    //           20,
                                                    //       actions: [
                                                    //         ElevatedButton(
                                                    //           child: Text(
                                                    //             'Close',
                                                    //             style: TextStyle(
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .w200),
                                                    //           ),
                                                    //           style: ElevatedButton
                                                    //               .styleFrom(
                                                    //             primary: ColorTheme
                                                    //                 .m_red,
                                                    //             shape: RoundedRectangleBorder(
                                                    //                 borderRadius:
                                                    //                     BorderRadius
                                                    //                         .circular(
                                                    //                             10.0)),
                                                    //           ),
                                                    //           onPressed: () async {
                                                    //             Navigator.pop(
                                                    //                 context);

                                                    //             setState(() {
                                                    //               ptitle.clear();
                                                    //               pDesc.clear();
                                                    //             });
                                                    //           },
                                                    //         ),
                                                    //         ElevatedButton(
                                                    //           child: Text(
                                                    //             'Edit',
                                                    //             style: TextStyle(
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .w200),
                                                    //           ),
                                                    //           style: ElevatedButton
                                                    //               .styleFrom(
                                                    //             primary: ColorTheme
                                                    //                 .m_blue,
                                                    //             shape: RoundedRectangleBorder(
                                                    //                 borderRadius:
                                                    //                     BorderRadius
                                                    //                         .circular(
                                                    //                             10.0)),
                                                    //           ),
                                                    //           onPressed: () async {
                                                    //             setState(() {
                                                    //               saveAttempt =
                                                    //                   true;
                                                    //             });

                                                    //             if (formkey
                                                    //                 .currentState!
                                                    //                 .validate()) {
                                                    //               formkey
                                                    //                   .currentState!
                                                    //                   .save();
                                                    //             }
                                                    //           },
                                                    //         ),
                                                    //       ],
                                                    //     )
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
                                                            email:
                                                                e.id.toString(),
                                                            uname: e.title,
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

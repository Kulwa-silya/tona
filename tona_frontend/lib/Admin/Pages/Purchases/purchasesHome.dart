import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Products/Addcollection.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/productViewer.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Purchases/Viewpurchases.dart';
import 'package:machafuapp/Admin/Pages/Purchases/addPurchasesProduct.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsales.dart';
import 'package:machafuapp/Admin/Pages/Sales/viewSale.dart';
import 'package:machafuapp/Admin/Shared/backarrow.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../globalconst/globalUrl.dart';

class PurchasesHome extends StatefulWidget {
  PurchasesHome({required this.Axtok, Key? key}) : super(key: key);
  String Axtok;
  @override
  State<PurchasesHome> createState() => _PurchasesHomeHomeState();
}

class _PurchasesHomeHomeState extends State<PurchasesHome> {
  var jsondat;

  String? accesTok;

  bool showsearchResult = false;
  bool collectionoffstg = false;

  String? searchValue;

  var jsonsearchData;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var _data;

  var data;

  var titleG, pidG, countG;

  TextEditingController searchController = new TextEditingController();

  fetchPurchasedProduct() async {
    final response = await http.get(
      Uri.parse('${globalUrl}procurement/purchase/'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.Axtok}",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    jsondat = jsonDecode(response.body);
    return jsondat;
  }

  searchSales() async {
    final response = await http.get(
      Uri.parse('${globalUrl}sales/sale/?search=$searchValue'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT $accesTok",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    jsonsearchData = jsonDecode(response.body);
    print(" joson serch ${jsonsearchData}");
    return jsonsearchData;
  }

  String getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  Future<void> _handleRefresh() async {
    // Fetch new data or update content
    await Future.delayed(Duration(seconds: 2)); // Simulate async fetch
    setState(() {
      _data = fetchPurchasedProduct(); // Update data
    });
  }

  @override
  void initState() {
    fetchPurchasedProduct();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfWeek = getDayOfWeek(now.weekday);
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPurchased(
                          Axtok: widget.Axtok,
                        )));
              },
              child: Center(
                child: Text("New Purchase", style: kInfoTextStyle),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        strokeWidth: 1,
        key: _refreshIndicatorKey,
        child: FutureBuilder(
            future: fetchPurchasedProduct(),
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
                                  searchSales();
                                });
                              },
                              onTap: () {
                                setState(() {
                                  showsearchResult = true;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Search Purchases',
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
                                future: searchSales(),
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
                                            int suppliername =
                                                snapshot.data[i]['supplier'];
                                            int puchaseId =
                                                snapshot.data[i]['id'];
                                            String date =
                                                snapshot.data[i]["date"];
                                            // String desc =
                                            //     snapshot.data[i]["description"];
                                            String unitprice =
                                                snapshot.data[i]["unit_price"];

                                            int? quantity =
                                                snapshot.data[i]["quantity"];
                                            // String img;
                                            // int imgId;
                                            // try {
                                            //   img = snapshot.data[i]["images"][0]
                                            //       ["image"];
                                            // } catch (e) {
                                            //   img = "assets/images/image_1.png";
                                            //   imgId = 0;
                                            // }

                                            return Builder(builder: (context) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewSales(
                                                                    saleId:
                                                                        puchaseId,
                                                                    date: date,
                                                                    salename:
                                                                        "Purchase from ${suppliername.toString()} for $dayOfWeek ${date == null ? DateTime.now().toString().substring(0, 16) : date.toString().substring(0, 16)}",
                                                                    accessTok:
                                                                        accesTok)));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
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
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              9),
                                                                      child: Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              myImageView(img: "assets/images/image_1.png")),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          suppliername
                                                                              .toString(),
                                                                          style:
                                                                              kBodyRegularTextStyle,
                                                                        ),
                                                                        Text(
                                                                          quantity
                                                                              .toString(),
                                                                          style:
                                                                              kTinyRegularTextStyle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Text(
                                                                          unitprice,
                                                                          style:
                                                                              kSmallBoldTextStyle,
                                                                        ),
                                                                        Text(
                                                                          date,
                                                                          style:
                                                                              kTinyRegularTextStyle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
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
                                    // try {
                                    data = jsondat[i];
                                    // pid = data['id'];
                                    // title = data['title'];
                                    // count = data['products_count'];
                                    // int sid = data['id'];
                                    // String cname = data['customer_name'];
                                    // String desc = data['description'];
                                    // String saleRevenue = data['sale_revenue'];
                                    // int count = data['total_quantity_sold'];
                                    // String date = data['date'];

                                    String? name =
                                        data['supplier']['full_name'];
                                    // String? lname =
                                    //     data['supplier']['user']['last_name'];
                                    String? phone =
                                        data['supplier']['phone_number'];
                                    int? puchaseId = data['id'];
                                    String date = data["date"];
                                    // String desc =
                                    //     snapshot.data[i]["description"];
                                    String unitprice = data["total_amount"];

                                    // int? quantity = data["quantity"];

                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 8, 16, 8),
                                      child: GestureDetector(
                                          onTap: (() {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewPurchase(
                                                          accessTok:
                                                              widget.Axtok,
                                                          date: date,
                                                          purchasename:
                                                              "Purchase from ${name} for $dayOfWeek ${date == null ? DateTime.now().toString().substring(0, 16) : date.toString().substring(0, 4)}",
                                                          purchaseId: puchaseId,
                                                        )));
                                          }),
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
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
                                                                        "assets/images/image_1.png")),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "$name",
                                                                style:
                                                                    kInfoTextStyle,
                                                              ),
                                                              Text(
                                                                "$phone",
                                                                style:
                                                                    kBodyRegularTextStyle,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                unitprice,
                                                                style:
                                                                    kSmallBoldTextStyle,
                                                              ),
                                                              Text(
                                                                date,
                                                                style:
                                                                    kTinyRegularTextStyle,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          )),
                                    );
                                    // } catch (e) {
                                    //   print("erra ni $e");
                                    //   return circularLoader();
                                    // }
                                  }
                                }),
                          ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

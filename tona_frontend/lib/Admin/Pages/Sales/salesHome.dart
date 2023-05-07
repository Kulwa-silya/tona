import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machafuapp/Admin/Pages/Products/Addcollection.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/productViewer.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
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

class SalesHome extends StatefulWidget {
  String Axtok;
  SalesHome({required this.Axtok, Key? key}) : super(key: key);

  @override
  State<SalesHome> createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  var jsondat;

  String? accesTok;

  bool showsearchResult = false;
  bool collectionoffstg = false;

  String? searchValue;

  var jsonsearchData;

  var data;

  var titleG, pidG, countG;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController searchController = new TextEditingController();

  var _data;

  fetchSalesCategory() async {
    final response = await http.get(
      Uri.parse('${globalUrl}sales/sale/'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.Axtok}",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    jsondat = jsonDecode(response.body);

    return jsondat;
  }

  Future<void> _handleRefresh() async {
    // Fetch new data or update content
    await Future.delayed(Duration(seconds: 2)); // Simulate async fetch
    setState(() {
      _data = fetchSalesCategory(); // Update data
    });
  }

  searchSales() async {
    final response = await http.get(
      Uri.parse('${globalUrl}sales/sale/?search=$searchValue'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.Axtok}",
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

  @override
  void initState() {
    fetchSalesCategory();

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
                    builder: (context) => AddSales(
                          axxtok: widget.Axtok,
                        )));
              },
              child: Center(
                child: Text("New Sale", style: kInfoTextStyle),
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
            future: fetchSalesCategory(),
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
                                labelText: 'Search Sales',
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
                                          physics: BouncingScrollPhysics(),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (cnt, i) {
                                            String cname = snapshot.data[i]
                                                ['customer_name'];
                                            int sId = snapshot.data[i]['id'];
                                            String date =
                                                snapshot.data[i]["date"];
                                            String desc =
                                                snapshot.data[i]["description"];
                                            String saleRevenue = snapshot
                                                .data[i]["sale_revenue"];
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
                                                                    saleId: sId,
                                                                    date: date,
                                                                    salename:
                                                                        "Sale to ${cname} for ${date == null ? DateTime.now().toString().substring(0, 19) : date.toString().substring(0, 1)}",
                                                                    accessTok:
                                                                        widget
                                                                            .Axtok)));
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
                                                                          cname,
                                                                          style:
                                                                              kBodyRegularTextStyle,
                                                                        ),
                                                                        Text(
                                                                          desc,
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
                                                                          saleRevenue,
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
                                    try {
                                      data = jsondat[i];
                                      // pid = data['id'];
                                      // title = data['title'];
                                      // count = data['products_count'];
                                      int sid = data['id'];
                                      String cname = data['customer_name'];
                                      String desc = data['description'];
                                      String saleRevenue = data['sale_revenue'];
                                      int count = data['total_quantity_sold'];
                                      String date = data['date'];

                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8, 16, 8),
                                        child: GestureDetector(
                                            onTap: (() {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewSales(
                                                            accessTok:
                                                                widget.Axtok,
                                                            date: date,
                                                            salename:
                                                                "Sale to ${cname} for ${date == null ? DateTime.now().toString().substring(0, 19) : date.toString().substring(0, 19)}",
                                                            saleId: sid,
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
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      cname,
                                                                      style:
                                                                          kInfoTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        color: ColorTheme
                                                                            .m_blue,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Center(
                                                                            child: Text(data["total_quantity_sold"].toString(),
                                                                                style: GoogleFonts.poppins(
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontSize: 10,
                                                                                  height: 1.5,
                                                                                  color: ColorTheme.m_white,
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  desc,
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  8.0, 0, 8, 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    saleRevenue,
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
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            )),
                                      );
                                    } catch (e) {
                                      print("erra ni $e");
                                      return circularLoader();
                                    }
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

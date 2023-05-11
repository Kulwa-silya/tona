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
import 'package:machafuapp/Admin/ui/shared/spacing.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../globalconst/globalUrl.dart';

class ReturnInwardsHome extends StatefulWidget {
  String Axtok;
  ReturnInwardsHome({required this.Axtok, Key? key}) : super(key: key);

  @override
  State<ReturnInwardsHome> createState() => _SalesHomeState();
}

class _SalesHomeState extends State<ReturnInwardsHome> {
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

  bool saveAttempt = false;

  bool success = false;

  bool authorised = false;

  int? sId;

  bool isExpanded = false;

  fetchReturnInwards() async {
    final response = await http.get(
      Uri.parse('${globalUrl}sales/return_inwards/'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.Axtok}",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    jsondat = jsonDecode(response.body);

    return jsondat;
  }

  Future aprooveReturn(int rid) async {
    final response = await http
        .patch(Uri.parse("${globalUrl}/sales/return_inwards/${rid}/"),
            headers: {
              HttpHeaders.authorizationHeader: "JWT ${widget.Axtok}",
              "Accept": "application/json",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "is_authorized": authorised,
            }))
        .then((value) async {
      setState(() {
        success = false;
      });
      print(value);
    });

    print("res ni ${response}");
  }

  Future<void> _handleRefresh() async {
    // Fetch new data or update content
    await Future.delayed(Duration(seconds: 2)); // Simulate async fetch
    setState(() {
      _data = fetchReturnInwards(); // Update data
    });
  }

  searchReturn() async {
    final response = await http.get(
      Uri.parse('${globalUrl}sales/return_inwards/?search=$searchValue'),
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
    fetchReturnInwards();

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
        leading: backArrow(
            towhere: MainView(
          Axtok: widget.Axtok,
        )),
        title: Text(
          "Return Inwards",
          style: kHeading3TextStyle,
        ),
        // centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        strokeWidth: 1,
        key: _refreshIndicatorKey,
        child: FutureBuilder(
            future: fetchReturnInwards(),
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
                                  searchReturn();
                                });
                              },
                              onTap: () {
                                setState(() {
                                  showsearchResult = true;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Search Returns',
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
                                future: searchReturn(),
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
                                            String rname = snapshot.data[i]
                                                ['sold_product_name'];
                                            sId = snapshot.data[i]['id'];
                                            String date =
                                                snapshot.data[i]["date"];
                                            String desc = snapshot.data[i]
                                                ["return_reason"];
                                            String? authorizedby = snapshot
                                                .data[i]["authorized_by"];
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
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             ViewSales(
                                                    //                 saleId: sId,
                                                    //                 date: date,
                                                    //                 salename:
                                                    //                     "Sale to ${cname} for ${date == null ? DateTime.now().toString().substring(0, 19) : date.toString().substring(0, 1)}",
                                                    //                 accessTok:
                                                    //                     widget
                                                    //                         .Axtok)));
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
                                                                          rname,
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
                                                                          authorizedby!,
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
                                    int rid = data['id'];
                                    String returnedprodt =
                                        data['sold_product_name'];
                                    String reaturnReason =
                                        data['return_reason'];
                                    int quantity = data['quantity_returned'];
                                    String? authorizedby =
                                        data['authorized_by'];
                                    bool isAuthorised = data['is_authorized'];
                                    String date = data['date'];

                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 8, 16, 8),
                                      child: GestureDetector(
                                          onTap: (() {
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ViewSales(
                                            //               accessTok:
                                            //                   widget.Axtok,
                                            //               date: date,
                                            //               salename:
                                            //                   "Return from ${reaturnReason} for ${date == null ? DateTime.now().toString().substring(0, 19) : date.toString().substring(0, 19)}",
                                            //               saleId: rid,
                                            //             )));
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
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    returnedprodt,
                                                                    style:
                                                                        kInfoTextStyle,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      color: ColorTheme
                                                                          .m_blue,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              quantity.toString(),
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
                                                              Container(
                                                                width: 200,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      isExpanded =
                                                                          !isExpanded;
                                                                    });
                                                                  },
                                                                  child: Wrap(
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    children: [
                                                                      Text(
                                                                        reaturnReason,
                                                                        style:
                                                                            kBodyRegularTextStyle,

                                                                        maxLines: isExpanded
                                                                            ? null
                                                                            : 1,
                                                                        overflow: isExpanded
                                                                            ? TextOverflow.visible
                                                                            : TextOverflow.ellipsis,
                                                                        // overflow:
                                                                        //     TextOverflow
                                                                        // .ellipsis,
                                                                      ),
                                                                      horizontalSpaceTiny,
                                                                      Text(
                                                                        "read more",
                                                                        style:
                                                                            kSmallBoldTextStyle,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
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
                                                            isAuthorised ==
                                                                    false
                                                                ? TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      authoriseDialog(
                                                                          context,
                                                                          returnedprodt,
                                                                          quantity,
                                                                          rid);
                                                                    },
                                                                    child: Text(
                                                                        "Authorize"))
                                                                : Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "authorized by",
                                                                        style:
                                                                            kSmallRegularTextStyle,
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            4,
                                                                            2,
                                                                            4,
                                                                            2),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                ColorTheme.m_white,
                                                                            borderRadius: BorderRadius.circular(15)),
                                                                        child:
                                                                            Text(
                                                                          authorizedby!,
                                                                          style:
                                                                              kSmallBoldTextStyle,
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "On ",
                                                                            style:
                                                                                kSmallBoldTextStyle,
                                                                          ),
                                                                          Text(
                                                                            "${date.substring(0, 10)} | ",
                                                                            style:
                                                                                kTinyRegularTextStyle,
                                                                          ),
                                                                          Text(
                                                                            "${date.substring(12, 16)}",
                                                                            style:
                                                                                kTinyRegularTextStyle,
                                                                          ),
                                                                        ],
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

  Future<dynamic> authoriseDialog(
      BuildContext context, String returnedprodt, int quantity, int id) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 8),
                      child: Center(
                        child: Text(
                          "Caution!",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Are you sure you want to authorise return of "),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${returnedprodt}(${quantity.toString()}) ? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorTheme.m_grey),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorTheme.m_red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Yes',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorTheme.m_blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () async {
                              setState(() {
                                saveAttempt = true;
                                authorised = true;
                              });
                              aprooveReturn(id);
                              // await Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Products(
                              //             id: widget.pid,
                              //           )),
                              //   (Route<dynamic> route) => false,
                              // );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

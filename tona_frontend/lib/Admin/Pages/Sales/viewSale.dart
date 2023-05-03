import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Admin/Pages/Products/productViewer.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsales.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsoldProducts.dart';
import 'package:machafuapp/Admin/Pages/Sales/salesHome.dart';
import 'package:machafuapp/Admin/Shared/backarrow.dart';
import 'package:machafuapp/Admin/Shared/myDeleteDialog.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';

class ViewSales extends StatefulWidget {
  int? saleId;
  String? accessTok, salename;
  String? date;
  ViewSales(
      {required this.saleId,
      required this.accessTok,
      required this.salename,
      required this.date,
      Key? key})
      : super(key: key);

  @override
  State<ViewSales> createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  var jsonsoldData;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var _data;

  void doNothing(BuildContext context) {}

  getSoldProducts() async {
    final response = await http.get(
      Uri.parse(
          'https://tona-production.up.railway.app/sales/soldproduct/?sale=${widget.saleId}'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.accessTok}",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    jsonsoldData = jsonDecode(response.body);
    print(" joson serch ${jsonsoldData}");
    return jsonsoldData;
  }

  Future<void> _handleRefresh() async {
    // Fetch new data or update content
    await Future.delayed(Duration(seconds: 2)); // Simulate async fetch
    setState(() {
      _data = getSoldProducts(); // Update data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorTheme.m_white,
          elevation: 0,
          title: Text(
            widget.date!,
            style: kInfoTextStyle,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddSales(axxtok: widget.accessTok,)));
                },
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      // AddSoldProd(
                      //     salename: widget.salename, saleId: widget.saleId);

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AddSoldProd(
                              saleId: widget.saleId,
                              showdropdown: true,
                              accessTok: widget.accessTok,
                              title: "Add Sold Product!",
                              salename: widget.salename,
                            );
                          });
                    },
                    icon: Icon(Icons.add),
                    color: ColorTheme.m_blue,
                  ),
                ),
              ),
            )
          ],
          centerTitle: true,
          leading: backArrow(
            towhere: SalesHome(Axtok:widget.accessTok! ,),
          )),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        strokeWidth: 1,
        key: _refreshIndicatorKey,
        child: FutureBuilder(
            future: getSoldProducts(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: circularLoader());
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          if (jsonsoldData == [] || snapshot.data.length <= 0) {
                            return Center(
                                child: Text(
                              "No sold products yet!",
                              style: kInfoTextStyle,
                            ));
                          } else {
                            String pname = snapshot.data[i]['product_title'];
                            String discout = snapshot.data[i]['discount'];
                            int quantity = snapshot.data[i]["quantity"];
                            int sid = snapshot.data[i]["id"];
                            double oPrice = snapshot.data[i]['original_price'];

                            double disprice =
                                oPrice * (double.parse(discout) / 100);
                            double netprice = oPrice - disprice;
                            double price = quantity * netprice;

                            return Slidable(
                              // Specify a key if the Slidable is dismissible.
                              key: ValueKey(0),

                              // The start action pane is the one at the left or the top side.
                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                // motion: ScrollMotion(),
                                motion: ScrollMotion(),

                                // A pane can dismiss the Slidable.
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: null,
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: null,
                                    backgroundColor: Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: Icons.share,
                                    label: 'Share',
                                  ),
                                ],
                              ),

                              // The end action pane is the one at the right or the bottom side.
                              endActionPane: const ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    flex: 2,
                                    onPressed: null,
                                    backgroundColor: Color(0xFF7BC043),
                                    foregroundColor: Colors.white,
                                    icon: Icons.archive,
                                    label: 'Archive',
                                  ),
                                  SlidableAction(
                                    onPressed: null,
                                    backgroundColor: Color(0xFF0392CF),
                                    foregroundColor: Colors.white,
                                    icon: Icons.save,
                                    label: 'Save',
                                  ),
                                ],
                              ),

                              // The child of the Slidable is what the user sees when the
                              // component is not dragged.
                              child: GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         ViewSales(saleId: sId, accessTok: accesTok)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 4, 16, 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Container(
                                          color: ColorTheme
                                              .m_blue_mpauko_zaidi_zaidi,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                              pname,
                                                              style:
                                                                  kInfoTextStyle,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child: Container(
                                                                height: 20,
                                                                width: 20,
                                                                color:
                                                                    ColorTheme
                                                                        .m_blue,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Center(
                                                                    child: Text(
                                                                        quantity
                                                                            .toString(),
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontSize:
                                                                              10,
                                                                          height:
                                                                              1.5,
                                                                          color:
                                                                              ColorTheme.m_white,
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          "@${oPrice.toString()}",
                                                          style:
                                                              kTinyRegularTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Container(
                                                            color: ColorTheme
                                                                .m_blue_mpauko_zaidi,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                price
                                                                    .toString(),
                                                                style:
                                                                    kSmallBoldTextStyle,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "${double.parse(discout)}%",
                                                          style:
                                                              kTinyRegularTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      child: Container(
                                                        color:
                                                            ColorTheme.m_white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AddSoldProd(
                                                                          saleId:
                                                                              widget.saleId,
                                                                          showdropdown:
                                                                              false,
                                                                          Pid:
                                                                              sid,
                                                                          accessTok:
                                                                              widget.accessTok,
                                                                          title:
                                                                              "Edit Sold Product!",
                                                                          salename:
                                                                              widget.salename,
                                                                        );
                                                                      });
                                                                },
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color:
                                                                      ColorTheme
                                                                          .m_blue,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 35,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (_) => myDeletedialog(
                                                                          pid:
                                                                              sid,
                                                                          whatpart:
                                                                              "soldproduct",
                                                                          salename: widget
                                                                              .salename,
                                                                          email:
                                                                              pname,
                                                                          date: widget
                                                                              .date,
                                                                          tit:
                                                                              pname));
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color:
                                                                      ColorTheme
                                                                          .m_red,
                                                                  size: 20,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  )),
                            );
                          }
                        }),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void deleteDialog(BuildContext context, int sid, String pname) {
    showDialog(
        context: context,
        builder: (_) => myDeletedialog(
            pid: sid,
            whatpart: "soldproduct",
            salename: widget.salename,
            email: pname,
            date: widget.date,
            tit: pname));
  }
}

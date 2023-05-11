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
import 'package:machafuapp/Admin/Pages/Purchases/purchasesHome.dart';
import 'package:machafuapp/Admin/Pages/Purchases/updatePurchase.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsales.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsoldProducts.dart';
import 'package:machafuapp/Admin/Pages/Sales/salesHome.dart';
import 'package:machafuapp/Admin/Shared/backarrow.dart';
import 'package:machafuapp/Admin/Shared/myDeleteDialog.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/spacing.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';

import '../../../globalconst/globalUrl.dart';

class ViewPurchase extends StatefulWidget {
  int? purchaseId;
  String accessTok, purchasename;
  String? date;
  ViewPurchase(
      {required this.purchaseId,
      required this.accessTok,
      required this.purchasename,
      this.date,
      Key? key})
      : super(key: key);

  @override
  State<ViewPurchase> createState() => _ViewPurchaseState();
}

class _ViewPurchaseState extends State<ViewPurchase> {
  var jsonsoldData;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var _data;

  var data;

  getPuchasedProducts() async {
    final response = await http.get(
      Uri.parse('${globalUrl}procurement/purchase/${widget.purchaseId}'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.accessTok}",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    jsonsoldData = jsonDecode(response.body);
    print(" joson serch ${jsonsoldData}");
    return jsonsoldData['purchased_products'];
  }

  Future<void> _handleRefresh() async {
    // Fetch new data or update content
    await Future.delayed(Duration(seconds: 2)); // Simulate async fetch
    setState(() {
      _data = getPuchasedProducts(); // Update data
    });
  }

  Future<dynamic> myEditor(BuildContext context, int sid, int qunt,
      String discount, String pname, int productId) {
    return showDialog(
        context: context,
        builder: (context) {
          return UpdatePurchase(
            saleId: widget.purchaseId,
            quntt: qunt,
            discount: discount,
            showdropdown: false,
            pname: pname,
            productId: productId,
            Pid: sid,
            accessTok: widget.accessTok,
            title: "Edit Purchased Product!",
            salename: widget.purchasename,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorTheme.m_white,
          elevation: 0,
          title: Column(
            children: [
              Text(
                widget.date!,
                style: kInfoTextStyle,
              ),
              Text(
                widget.purchasename!,
                style: kTinyRegularTextStyle,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PurchasesHome(
                            Axtok: widget.accessTok!,
                          )));
                },
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      // AddSoldProd(
                      //     salename: widget.salename, saleId: widget.saleId);

                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AddSoldProd(
                      //           saleId: widget.purchaseId,
                      //           showdropdown: true,
                      //           accessTok: widget.accessTok,
                      //           title: "Add Sold Product!",
                      //           salename: widget.purchasename);
                      //     });
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
            towhere: PurchasesHome(
              Axtok: widget.accessTok!,
            ),
          )),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        strokeWidth: 1,
        key: _refreshIndicatorKey,
        child: FutureBuilder(
            future: getPuchasedProducts(),
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
                            data = jsonsoldData;
                            String pname =
                                data['purchased_products'][i]['product_name'];

                            // String discout = snapshot.data[i]['discount'];
                            int productId = data["purchased_products"][i]['id'];
                            int quantity =
                                data["purchased_products"][i]['quantity'];
                            int sid = data["id"];
                            String price =
                                data['purchased_products'][i]['unit_price'];

                            // double disprice =
                            //     oPrice * (double.parse(discout) / 100);
                            // double netprice = oPrice - disprice;
                            // double price = quantity * netprice;

                            return Slidable(
                              key: ValueKey(0),

                              // The start action pane is the one at the left or the top side.
                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                // motion: ScrollMotion(),
                                motion: ScrollMotion(),
                                dragDismissible: false,
                                // A pane can dismiss the Slidable.
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: (context) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => myDeletedialog(
                                                pid: productId,
                                                date: widget.date,
                                                acctok: widget.accessTok,
                                                whatpart: "purchasedproduct",
                                                salename: pname,
                                              ));
                                    },
                                    backgroundColor: ColorTheme.m_red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: null,
                                    backgroundColor: ColorTheme.m_blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.share,
                                    label: 'Share',
                                  ),
                                ],
                              ),

                              // The end action pane is the one at the right or the bottom side.
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    // flex: 2,
                                    onPressed: null,
                                    backgroundColor:
                                        Color.fromARGB(255, 57, 105, 17),
                                    foregroundColor: Colors.white,
                                    icon: Icons.archive,
                                    label: 'Archive',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      myEditor(context, sid, quantity, "2",
                                          pname, productId);
                                    },
                                    flex: 2,
                                    backgroundColor: ColorTheme.m_blue_mpauko,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit_rounded,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
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
                                                              pname.toString(),
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
                                                                          2.0),
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
                                                          "@${price.toString()}",
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        color: ColorTheme
                                                            .m_blue_mpauko_zaidi,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                            price.toString(),
                                                            style:
                                                                kSmallBoldTextStyle,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    verticalSpaceSmall,
                                                    Text(
                                                      "$price %",
                                                      style:
                                                          kTinyRegularTextStyle,
                                                    ),
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
}

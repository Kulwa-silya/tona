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
import 'package:machafuapp/Admin/ui/shared/spacing.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';

class ViewSales extends StatefulWidget {
  int? saleId;
  String accessTok, salename;
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

  var pname;

  var productId;

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

  void myFunction(BuildContext? context) {
    // function body
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddSales(
                            axxtok: widget.accessTok,
                          )));
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
                              pname: pname,
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
            towhere: SalesHome(
              Axtok: widget.accessTok!,
            ),
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
                            pname = snapshot.data[i]['product_title'];
                            productId = snapshot.data[i]['product'];
                            String discout = snapshot.data[i]['discount'];
                            int quantity = snapshot.data[i]["quantity"];
                            int sid = snapshot.data[i]["id"];
                            double oPrice = snapshot.data[i]['original_price'];
                            bool returnsts = snapshot.data[i]
                                ['return_inwards_authorised']['status'];
                            int? returnId = snapshot.data[i]
                                    ['return_inwards_authorised']
                                ['unauthorised_return_id'];

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
                                dragDismissible: false,
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: (context) {
                                      deleteDialog(context, sid, pname);
                                    },
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
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    // An action can be bigger than the others.
                                    // flex: 2,
                                    onPressed: null,
                                    backgroundColor: Color(0xFF7BC043),
                                    foregroundColor: Colors.white,
                                    icon: Icons.archive,
                                    label: 'Archive',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      myEditor(context, sid, quantity, discout,
                                          pname, productId);
                                    },
                                    flex: 2,
                                    backgroundColor: Color(0xFF0392CF),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit_rounded,
                                    label: 'Edit',
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
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            color: ColorTheme
                                                .m_blue_mpauko_zaidi_zaidi,
                                            border: returnsts == true
                                                ? null
                                                : Border.all(
                                                    color: ColorTheme
                                                        .m_warning_mpauko, // Set your desired border color
                                                    width:
                                                        2.0, // Set your desired border width
                                                  ),
                                          ),
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
                                                            horizontalSpaceSmall,
                                                            returnsts == true
                                                                ? SizedBox
                                                                    .shrink()
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      color: ColorTheme
                                                                          .m_white,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              "pending return",
                                                                              style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 10,
                                                                                height: 1.5,
                                                                                color: ColorTheme.m_red,
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
                                                          child: Text(
                                                            "${double.parse(discout)}%",
                                                            style:
                                                                kTinyRegularTextStyle,
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

  Future<dynamic> myEditor(BuildContext context, int sid, int qunt,
      String discount, String pname, int productId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddSoldProd(
            saleId: widget.saleId,
            quntt: qunt,
            discount: discount,
            showdropdown: false,
            pname: pname,
            productId: productId,
            Pid: sid,
            accessTok: widget.accessTok,
            title: "Edit Sold Product!",
            salename: widget.salename,
          );
        });
  }

  void deleteDialog(BuildContext context, int sid, String pname) {
    showDialog(
        context: context,
        builder: (_) => myDeletedialog(
            pid: sid,
            acctok: widget.accessTok,
            whatpart: "soldproduct",
            salename: widget.salename,
            email: pname,
            date: widget.date,
            tit: pname));
  }
}

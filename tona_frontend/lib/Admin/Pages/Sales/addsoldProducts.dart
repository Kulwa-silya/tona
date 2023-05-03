import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:machafuapp/Admin/Controllers/productsProvider.dart';
import 'package:machafuapp/Admin/Models/getProducts.dart';
import 'package:machafuapp/Admin/Pages/Sales/salesHome.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:machafuapp/Shared/gettingTokens.dart';
import 'package:machafuapp/globalconst/globalUrl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shimmer/shimmer.dart';

import '../../consts/colorTheme.dart';

class AddSoldProd extends StatefulWidget {
  AddSoldProd(
      {required this.salename,
      required this.title,
      this.pname,
      required this.accessTok,
      required this.saleId,
      this.discount,
      this.quntt,
      this.productId,
      this.Pid,
      required this.showdropdown,
      Key? key})
      : super(key: key);
  String? salename, title, discount, accessTok, pname;

  bool? showdropdown = true;

  int? saleId, Pid, quntt, productId;
  @override
  State<AddSoldProd> createState() => _AddSoldProdState();

  GettingToken gettingToken = new GettingToken();
}

class _AddSoldProdState extends State<AddSoldProd> {
  bool saveAttempt = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController quantityC = new TextEditingController();
  TextEditingController reasoanC = new TextEditingController();
  TextEditingController discoutC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController searchdropdown = new TextEditingController();
  bool loading = false;

  DateTime? gdate;
  String? productname;
  bool success = false;
  bool successErr = false;

  bool showsnack = false;

  var jsonProdData;

  dynamic dropdownvalue2 = [
    {"id": 0, "name": 'Select Product'}
  ];

  String dropdownvalue = 'Select Product one';
  // List of items in our dropdown menu
  // var items1 = [
  //   'Select Category     ',
  //   'Cat 1',
  //   'Cat 2',
  //   'Cat 3',
  //   'Cat 4',
  //   'Cat 5',
  // ];

  // List<String> items = [];

  List<Map<String, dynamic>> items = [];

  int? pId;

  int? selectedIndex;
  String? _selectedItem;

  List listprod = [];

  List productIds = [];

  var selectedProductId;

  int? quantity;

  bool shoetextfield = false;

  var count;

  getProducts() async {
    final response = await http.get(
      Uri.parse("${globalUrl}store/products/"),
    );
    jsonProdData = jsonDecode(response.body);
    // print(jsonsearchData[0]['results']);
    // items.add(jsonProdData[0]['results']);
    setState(() {
      items.add({"id": 0, "name": "Select Product"});
      for (int i = 0; i < jsonProdData["count"]; i++) {
        items.add({
          "id": jsonProdData['results'][i]['id'],
          "name": jsonProdData['results'][i]['title']
        });
        //  pId =jsonProdData['results'][i]['title'];
        productIds.add(jsonProdData['results'][i]['id']);
      }
    });
  }

  getProductsCount(int id) async {
    final response = await http.get(
      Uri.parse("${globalUrl}store/products/${id}"),
    );
    jsonProdData = jsonDecode(response.body);

    setState(() {
      print("id ni $id");
      count = jsonProdData['inventory'];

      print("idadi ni: $count");
    });

    return count;
  }

  getProductsCount2() async {
    final response = await http.get(
      Uri.parse("${globalUrl}store/products/${widget.productId}"),
    );
    jsonProdData = jsonDecode(response.body);

    setState(() {
      // print("id ni $id");
      count = jsonProdData['inventory'];

      print("idadi ni: $count");
    });

    return count;
  }

  Future _addsoldProd() async {
    try {
      final res = await http
          .post(
              Uri.parse(
                  "https://tona-production.up.railway.app/sales/soldproduct/"),
              headers: {
                HttpHeaders.authorizationHeader: "JWT  ${widget.accessTok}",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                "quantity": int.parse(quantityC.text),
                "product": selectedProductId,
                "discount": discoutC.text,
                "sale": widget.saleId
              }))
          .then((value) async {
        setState(() {
          success = false;
          showsnack = true;
        });
      });

      return res;
    } catch (e) {
      setState(() {
        success = false;
        successErr = true;
      });
    }

    print(success);
  }

  Future updateSoldProd() async {
    final response = await http
        .patch(
            Uri.parse(
                "https://tona-production.up.railway.app/sales/soldproduct/${widget.Pid}/"),
            headers: {
              HttpHeaders.authorizationHeader: "JWT ${widget.accessTok}",
              "Accept": "application/json",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "quantity": int.parse(quantityC.text),
              "discount": discoutC.text
            }))
        .then((value) async {
      setState(() {
        success = false;
        showsnack = true;
      });
      print(value);
    });

    print("res ni $response");
  }

  @override
  void initState() {
    getProducts();

    getProductsCount2();

    widget.quntt == null
        ? quantityC.text = ""
        : quantityC.text = widget.quntt.toString();
    widget.quntt == null ? quantity = null : quantity = widget.quntt;

    // quantity = widget.quntt!;

    widget.discount == null
        ? discoutC.text = ""
        : discoutC.text = widget.discount!;

    print("${widget.gettingToken.getAccessToken()}");

    print("qunt ni  $quantity ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 2),
                child: Center(
                  child: Text("${widget.title}", style: kHeading3TextStyle),
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                        child: Center(
                          child: Text("On", style: kInfoRegularTextStyle),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0, 8, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: ColorTheme.m_blue_mpauko_zaidi,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Text("${widget.salename}",
                                    style: kBodyRegularTextStyle),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        widget.showdropdown == false
                            ? SizedBox.shrink()
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16.0, 12, 16, 8),
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: SearchField(
                                        hint: 'Search',
                                        searchInputDecoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: ColorTheme
                                                  .m_blue_mpauko_zaidi,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2,
                                              color: ColorTheme.m_blue
                                                  .withOpacity(0.8),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        maxSuggestionsInViewPort: 6,
                                        itemHeight: 50,
                                        suggestionState:
                                            SuggestionState.enabled,
                                        suggestionsDecoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        // initialValue: items[1]['name'],
                                        onTap: (value) {
                                          setState(() {
                                            _selectedItem = value!;

                                            int selectedIndex =
                                                items.indexWhere((item) =>
                                                    item["name"] == value);
                                            if (selectedIndex != -1) {
                                              // Make sure the selected index is valid
                                              selectedProductId =
                                                  productIds[selectedIndex - 1];

                                              getProductsCount(
                                                  selectedProductId);

                                              print(
                                                  "Selected product Index: $selectedIndex");
                                              print(
                                                  "Selected product ID: $selectedProductId");
                                            }
                                          });

                                          print("list of : ${productIds}");

                                          print(value);
                                          print(items
                                              .map((item) => item["name"])
                                              .toList());
                                        },
                                        suggestions: items
                                            .map<String>((item) =>
                                                item["name"] as String)
                                            .toList()
                                        // .map((e) =>
                                        //     SearchFieldListItem(e,
                                        //         child: Text(e)))
                                        // .toList(),
                                        ),
                                  ),
                                ),
                              ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () {
                                getProductsCount2();
                              },
                              validator: (Value) {
                                if (Value!.isEmpty) {
                                  return "Fill in product quantity";
                                }
                                if (count == null) {
                                  getProductsCount2();
                                  return "Loading...";
                                } else {
                                  if (int.parse(Value) > count) {
                                    return "There only $count available!";
                                  }
                                }

                                RegExp regExp = new RegExp(r'^[0-9]+$');
                                if (regExp.hasMatch(Value)) {
                                  return null;
                                }
                                return "Invalid Quantity Format";
                              },
                              controller: quantityC,
                              onChanged: (val) {
                                if (quantity == null) {
                                  return null;
                                } else {
                                  if (int.tryParse(val) != null &&
                                      int.parse(val) < quantity!) {
                                    setState(() {
                                      shoetextfield = true;
                                    });
                                  } else {
                                    setState(() {
                                      shoetextfield = false;
                                    });
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.numbers,
                                ),
                                labelText: "Quantity",
                                hintText: "Ex: 6",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                              ),
                            ),
                          ),
                        ),
                        shoetextfield == true
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (emailValue) {
                                      if (emailValue!.isEmpty) {
                                        return "Fill in reason for return";
                                      }
                                      RegExp regExp = new RegExp(
                                          "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                                      if (regExp.hasMatch(emailValue)) {
                                        return null;
                                      }
                                      return "Invalid Reason Format";
                                    },
                                    controller: reasoanC,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.adobe_sharp,
                                      ),
                                      labelText: "Reason",
                                      hintText: "Ex: Reason for the return...",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: ColorTheme.m_blue_mpauko_zaidi,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (emailValue) {
                                if (emailValue!.isEmpty) {
                                  return "Fill in discount";
                                }
                                RegExp regExp =
                                    new RegExp(r'^\d+(\.\d{1,2})?$');
                                if (regExp.hasMatch(emailValue)) {
                                  return null;
                                }
                                return "Invalid discount format";
                              },
                              controller: discoutC,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.discount_rounded),
                                labelText: "Discount",
                                hintText: "Ex: 10%",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                              ),
                            ),
                          ),
                        ),

                        success == true
                            ? circularLoader()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorTheme.m_red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          widget.showdropdown = true;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.showdropdown == false
                                                ? 'Edit'
                                                : 'Add',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorTheme.m_blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          saveAttempt = true;
                                        });

                                        if (formkey.currentState!.validate()) {
                                          formkey.currentState!.save();
                                          widget.showdropdown == true
                                              ? _addsoldProd()
                                              : updateSoldProd();
                                          setState(() {
                                            success = true;
                                            // widget.showdropdown = true;
                                            // successErr = true;
                                          });
                                          if (success == true)
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "added (${productname})",
                                                  style: TextStyle(
                                                      color: ColorTheme.m_blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor: ColorTheme
                                                  .m_blue_mpauko_zaidi,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 30,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              padding: EdgeInsets.all(3),
                                              action: SnackBarAction(
                                                label: 'Dismiss',
                                                disabledTextColor: Colors.white,
                                                textColor: ColorTheme.m_blue,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  //Do whatever you want
                                                },
                                              ),
                                            ));

                                          if (successErr == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Opps!, parhaps check your internet connection",
                                                  style: TextStyle(
                                                      color: ColorTheme.m_white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 103, 13, 7),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 30,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              padding: EdgeInsets.all(3),
                                              action: SnackBarAction(
                                                label: 'Dismiss',
                                                disabledTextColor: Colors.white,
                                                textColor: ColorTheme.m_white,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  //Do whatever you want
                                                },
                                              ),
                                            ));
                                          }
                                          // _useradd();
                                        } else {
                                          if (successErr == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Opps!, parhaps check your internet connection",
                                                  style: TextStyle(
                                                      color: ColorTheme.m_white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 103, 13, 7),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 30,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              padding: EdgeInsets.all(3),
                                              action: SnackBarAction(
                                                label: 'Dismiss',
                                                disabledTextColor: Colors.white,
                                                textColor: ColorTheme.m_white,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  //Do whatever you want
                                                },
                                              ),
                                            ));
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                        // success ==false ?
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

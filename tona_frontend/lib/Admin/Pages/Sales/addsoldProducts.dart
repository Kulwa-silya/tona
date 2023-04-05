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
import 'package:shimmer/shimmer.dart';

import '../../consts/colorTheme.dart';

class AddSoldProd extends StatefulWidget {
  AddSoldProd({required this.salename, required this.saleId, Key? key})
      : super(key: key);
  String? salename;
  int? saleId;
  @override
  State<AddSoldProd> createState() => _AddSoldProdState();

  GettingToken gettingToken = new GettingToken();
}

class _AddSoldProdState extends State<AddSoldProd> {
  bool saveAttempt = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController quantityC = new TextEditingController();
  TextEditingController discoutC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  bool loading = false;

  DateTime? gdate;
  String? productname;
  bool success = false;
  bool successErr = false;

  bool showsnack = false;

  var jsonProdData;

  dynamic dropdownvalue = [
    {"id": 0, "name": 'Select Product'}
  ];

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

  getProducts() async {
    final response = await http.get(
      Uri.parse("https://tona-production.up.railway.app/store/products/"),
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
      }
    });

    print("dataaa $items");
    // print(items1);
    return items;
  }

  Future _addsoldProd() async {
    try {
      final res = await http
          .post(
              Uri.parse(
                  "https://tona-production.up.railway.app/sales/soldproduct/"),
              headers: {
                HttpHeaders.authorizationHeader:
                    "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgwOTYwMDYyLCJqdGkiOiI5ZGRlNmI4ODA4NzE0YjdmYThiMjc2MjQyNDAyN2IyZiIsInVzZXJfaWQiOjF9.72vmK9qxwRcj-D602SEKvKjdImq-mBGPX8cyfvqJyxQ",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                "quantity": int.parse(quantityC.text),
                "product": pId,
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

  @override
  void initState() {
    getProducts();

    print("${widget.gettingToken.getAccessToken()}");
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
                  child: Text("Add Sold Product!", style: kHeading3TextStyle),
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
                        items == null
                            ? Shimmer(
                                period: Duration(seconds: 5),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    ColorTheme.m_grey,
                                    ColorTheme.m_white
                                  ],
                                ),
                                child: Container(
                                  height: 13,
                                  width: 200,
                                ), // ,
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16.0, 12, 16, 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                    child: Center(
                                      child: DropdownButton(
                                        dropdownColor: ColorTheme.m_white,
                                        style: kBodyRegularTextStyle,
                                        hint: Text("Loading..."),
                                        // underline: Container(
                                        //   height: 2,
                                        //   width: 200,
                                        //   color: ColorTheme.m_blue,
                                        // ),
                                        value: dropdownvalue[0]["name"],
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: ColorTheme.m_blue,
                                        ),
                                        items: items.map((item) {
                                          return DropdownMenuItem(
                                            value: item['id'],
                                            child: Text(item['name']),
                                          );
                                        }).toList(),
                                        onChanged: (dynamic newValue) {
                                          setState(() {
                                            dropdownvalue = newValue[0]['name'];
                                            pId = items.firstWhere((item) =>
                                                item["id"] == newValue)["id"];
                                          });
                                        },
                                      ),
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
                              validator: (Value) {
                                if (Value!.isEmpty) {
                                  return "Fill in product quantity";
                                }
                                RegExp regExp = new RegExp(r'^[0-9]+$');
                                if (regExp.hasMatch(Value)) {
                                  return null;
                                }
                                return "Invalid Quantity Format";
                              },
                              controller: quantityC,
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
                                RegExp regExp = new RegExp(r'^[0-9]+$');
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
                                            'Add',
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

                                          _addsoldProd();
                                          setState(() {
                                            success = true;
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

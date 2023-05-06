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
import 'package:shimmer/shimmer.dart';

import '../../consts/colorTheme.dart';

class AddSupplier extends StatefulWidget {
  AddSupplier(
      {this.salename,
      this.title,
      required this.accessTok,
      this.saleId,
      this.Pid,
      this.showdropdown,
      Key? key})
      : super(key: key);
  String? salename, title, accessTok;
  bool? showdropdown = true;

  int? saleId, Pid;
  @override
  State<AddSupplier> createState() => _AddSupplierState();

  GettingToken gettingToken = new GettingToken();
}

class _AddSupplierState extends State<AddSupplier> {
  bool saveAttempt = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController AddressC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController nameC = new TextEditingController();

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

  Future _addSupplier() async {
    try {
      final res = await http
          .post(Uri.parse("${globalUrl}procurement/supplier/"),
              headers: {
                HttpHeaders.authorizationHeader: "JWT  ${widget.accessTok}",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                "full_name": nameC.text,
                "phone_number": "+255${phoneC.text}",
                "address": AddressC.text
              }))
          .then((value) async {
        print(" resss ni ${jsonDecode(value.body)} ");
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
    print("${widget.gettingToken.getAccessToken()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 900,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 31, 8, 2),
              child: Center(
                child: Text("New Supplier", style: kHeading2TextStyle),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (Value) {
                              if (Value!.isEmpty) {
                                return "Fill in full name";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(Value)) {
                                return null;
                              }
                              return "Invalid name Format";
                            },
                            controller: nameC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.numbers,
                              ),
                              labelText: "Full name",
                              hintText: "Ex: Cocacola,Pepsi",
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
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (Value) {
                              if (Value!.isEmpty) {
                                return "Fill in Address quantity";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(Value)) {
                                return null;
                              }
                              return "Invalid Address Format";
                            },
                            controller: AddressC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.numbers,
                              ),
                              labelText: "Address",
                              hintText: "Ex: Sabasaba, NSSF",
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
                            maxLength: 9,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return "Fill in Phone number";
                              }
                              RegExp regExp = new RegExp(r'^[0-9]+$');
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Phone Number Format";
                            },
                            controller: phoneC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                              ),
                              labelText: "Phone Name",
                              hintText: "Ex: Electronics",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                              prefix: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 5, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: ColorTheme.m_blue_mpauko_zaidi,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "+255",
                                          style: kInfoRegularTextStyle,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      success == true
                          ? circularLoader()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Close',
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

                                        _addSupplier();

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
                                            backgroundColor:
                                                ColorTheme.m_blue_mpauko_zaidi,
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
                                            backgroundColor:
                                                Color.fromARGB(255, 103, 13, 7),
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
                                            backgroundColor:
                                                Color.fromARGB(255, 103, 13, 7),
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
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}

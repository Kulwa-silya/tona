import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';

import '../../Shared/myTextFormField.dart';
import '../../consts/colorTheme.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  TextEditingController titleC = new TextEditingController();
  TextEditingController descC = new TextEditingController();
  TextEditingController inveC = new TextEditingController();
  TextEditingController unitPC = new TextEditingController();
  TextEditingController PricTC = new TextEditingController();
  TextEditingController CollectionC = new TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool loading = false;

  String dropdownvalue = 'Select Category     ';

  // List of items in our dropdown menu
  var items = [
    'Select Category     ',
    'Cat 1',
    'Cat 2',
    'Cat 3',
    'Cat 4',
    'Cat 5',
  ];

  void _productadd() async {
    final response = await http.post(
        Uri.parse("https://tona-production-8ea1.up.railway.app/store/producs/"),
        headers: {
          // HttpHeaders.authorizationHeader: "JWT ${widget.axxton}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "title": titleC.text,
          "description": descC.text,
          "inventory": int.parse(inveC.text),
          "unit_price": unitPC.text,
          "price_with_tax": int.parse(PricTC.text),
          "collection": int.parse(CollectionC.text),
          "image": null
        }));
    var res = json.decode(response.body);

    print(res);

    print(response.body);
  }

  bool saveAttempt = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => Products()));
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
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: ColorTheme.m_white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8, 10, 8),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "New Product",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      mytextField(
                          contro: titleC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Taa",
                          hintLebel: "Product Name",
                          validateText: "Fill in your product name",
                          finalvalidateText: "Invalid Name Format",
                          icodata: Icons.adobe_sharp,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                                new RegExp('[a-zA-Z]'))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                      mytextField(
                          contro: descC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Maelezo juu ya bidhaa",
                          hintLebel: "Description",
                          validateText: "Fill in your Description",
                          finalvalidateText: "Invalid Description Format",
                          icodata: Icons.description,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                                new RegExp('[a-zA-Z]'))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          dropdownColor: ColorTheme.m_white,
                          style: TextStyle(color: ColorTheme.m_blue),
                          hint: Text("Select"),
                          underline: Container(
                            height: 2,
                            color: ColorTheme.m_blue,
                          ),
                          value: dropdownvalue,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: ColorTheme.m_blue,
                          ),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      mytextField(
                          contro: inveC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 2",
                          hintLebel: "Inventory",
                          validateText: "Fill in your Inventory Number",
                          finalvalidateText: "Invalid Inventory Format",
                          icodata: Icons.inventory,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(
                                new RegExp(r"\s\b|\b\s"))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      mytextField(
                          contro: unitPC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 500",
                          hintLebel: "Unit Price",
                          validateText: "Fill in your Unit Price",
                          finalvalidateText: "Invalid unit price Format",
                          icodata: Icons.monetization_on,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(
                                new RegExp(r"\s\b|\b\s"))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      mytextField(
                          contro: PricTC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 535",
                          hintLebel: "Price with Tax",
                          validateText: "Fill in your Price with Tax",
                          finalvalidateText: "Invalid Price with Tax Format",
                          icodata: Icons.monetization_on_outlined,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(
                                new RegExp(r"\s\b|\b\s"))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      mytextField(
                          contro: CollectionC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 1",
                          hintLebel: "Collections",
                          validateText: "Fill in your Collection",
                          finalvalidateText: "Invalid Collection Format",
                          icodata: Icons.collections_bookmark,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.deny(
                                new RegExp(r"\s\b|\b\s"))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 60.0, vertical: 25.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add',
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
                              });

                              if (formkey.currentState!.validate()) {
                                formkey.currentState!.save();

                                _productadd();
                                // _useradd();
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

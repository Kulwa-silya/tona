import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';

import '../../Shared/myTextFormField.dart';
import '../../consts/colorTheme.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({Key? key}) : super(key: key);

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  TextEditingController uname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
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
                          contro: fname,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Taa",
                          hintLebel: "Name",
                          validateText: "Fill in your product name",
                          finalvalidateText: "Invalid Name Format",
                          icodata: Icons.person,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                                new RegExp('[a-zA-Z]'))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                      mytextField(
                          contro: lname,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 20,000/=",
                          hintLebel: "Price",
                          validateText: "Fill in your price",
                          finalvalidateText: "Invalid Name Format",
                          icodata: Icons.person,
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
                          contro: uname,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 20,000",
                          hintLebel: "Price",
                          validateText: "Fill in your price",
                          finalvalidateText: "Invalid price Format",
                          icodata: Icons.monetization_on,
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(
                                new RegExp(r"\s\b|\b\s"))
                          ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
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

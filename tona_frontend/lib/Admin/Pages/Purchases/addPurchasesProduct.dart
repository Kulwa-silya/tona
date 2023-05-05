import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:machafuapp/Admin/Pages/Products/addproduct.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Products/productsCategory.dart';
import 'package:machafuapp/Admin/Pages/Purchases/purchasesHome.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsoldProducts.dart';
import 'package:machafuapp/Admin/Pages/Sales/salesHome.dart';
import 'package:machafuapp/Admin/Shared/CustomDateTimePicker.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:machafuapp/globalconst/globalUrl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Shared/myTextFormField.dart';
import '../../consts/colorTheme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'addSupplier.dart';

class AddPurchased extends StatefulWidget {
  int? pid;
  String? titl;
  String Axtok;
  AddPurchased({required this.Axtok, this.pid, this.titl, Key? key})
      : super(key: key);

  @override
  State<AddPurchased> createState() => _AddPurchasedState();
}

class _AddPurchasedState extends State<AddPurchased> {
  // TextEditingController cnameC = new TextEditingController();
  TextEditingController amountC = new TextEditingController();
  TextEditingController fullnameC = new TextEditingController();
  TextEditingController quantityC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController addressC = new TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool loading = false;

  // List of items in our dropdown menu
  List<Map<String, dynamic>> items = [];

  List<Map<String, dynamic>> products = [];

  bool success = false;

  bool successErr = false;

  String? accesTok;

  String? imgPath;
  String imgName = "Image not sesected";

  dynamic base64Image;

  Uint8List? bytes;

  var jsonre;

  var id;

  XFile? pickedFile;

  File? _imageFile;

  bool _isImageSelected = false;

  DateTime? gdate;

  bool showsnack = false;

  int? selectedSupplierId, selectedProductId;

  String? _selectedItem;

  List supplierIds = [];
  List productIds = [];

  var jsonSupplierData;

  var jsonProdData;

  bool _isSelected = false;

  String _value = "CA";

  getSupplier() async {
    clearItems();
    final response = await http.get(
      Uri.parse("${globalUrl}procurement/supplier/"),
      headers: {
        HttpHeaders.authorizationHeader: "JWT ${widget.Axtok}",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) {
      jsonSupplierData = jsonDecode(value.body);
      // print(jsonsearchData[0]['results']);
      // items.add(jsonProdData[0]['results']);
      setState(() {
        // items.add({"id": 0, "name": "Select Product"});
        print("datz $jsonSupplierData");
        for (int i = 0; i < jsonSupplierData.length; i++) {
          items.add({
            "id": jsonSupplierData[i]['id'],
            "name": jsonSupplierData[i]['full_name']
          });
          //  pId =jsonProdData['results'][i]['title'];
          supplierIds.add(jsonSupplierData[i]['id']);
        }
      });
    });
  }

  void clearItems() {
    items.clear();
  }

  void clearProds() {
    products.clear();
  }

  getProducts() async {
    clearProds();
    final response = await http.get(
      Uri.parse("${globalUrl}store/products/"),
    );
    jsonProdData = jsonDecode(response.body);
    // print(jsonsearchData[0]['results']);
    // items.add(jsonProdData[0]['results']);
    setState(() {
      // items.add({"id": 0, "name": "Select Product"});
      for (int i = 0; i < jsonProdData["count"]; i++) {
        products.add({
          "id": jsonProdData['results'][i]['id'],
          "name": jsonProdData['results'][i]['title']
        });
        //  pId =jsonProdData['results'][i]['title'];
        productIds.add(jsonProdData['results'][i]['id']);
      }
    });
  }

  @override
  void initState() {
    getSupplier();
    getProducts();

    phoneC.addListener(() {
      final text = phoneC.text;
      if (text.isNotEmpty && text.startsWith('0')) {
        phoneC.text = text.substring(1);
        phoneC.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneC.text.length),
        );
      }
    });
    super.initState();
  }

  void _showBottomSheet(Widget wid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              // You can customize the appearance of the bottom sheet here
              child: wid),
        );
      },
    );
  }

  void _handleValueChanged(String newValue) {
    setState(() {
      _value = newValue;
    });
  }

  Future _purchasedadd() async {
    try {
      final res = await http
          .post(Uri.parse("${globalUrl}procurement/purchase/"),
              headers: {
                HttpHeaders.authorizationHeader:
                    "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMzY5OTgzLCJqdGkiOiI0MWI5MTMzNmFkY2M0NmU4OWU0ODNlMWMxZGI3ZjFhNCIsInVzZXJfaWQiOjF9.QmlWLBpnOjoCcMqiAlQNSXqCit1sMxS9TzWFmRfuZyg",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                // "customer_name": cnameC.text,
                // "phone_number": "+255${phoneC.text}",
                // "description": descC.text,
                // "date":
                //     gdate == null ? DateTime.now().toString() : gdate.toString(),

                "date": gdate == null
                    ? DateTime.now().toString().substring(0, 10)
                    : gdate.toString().substring(0, 10),
                "total_amount": amountC.text,
                "payment_method": _value,
                "supplier": selectedSupplierId,
                "purchased_products": [
                  {
                    "unit_price": amountC.text,
                    "quantity": int.parse(quantityC.text),
                    "product": selectedProductId
                  }
                ]
              }))
          .then((value) async {
        jsonre = jsonDecode(value.body);
        setState(() {
          id = jsonre['id'];
          print("id ni: $id");
          print(gdate);
          success = false;
        });
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

  bool saveAttempt = false;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfWeek = getDayOfWeek(now.weekday);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => PurchasesHome(
                      Axtok: widget.Axtok,
                    )));
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
                          "New Purchase",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 12, 16, 8),
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
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  print("it is clicked");
                                  getSupplier();
                                });
                              }),
                              child: SearchField(
                                  hint: 'Search Supplier',
                                  searchInputDecoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          _showBottomSheet(AddSupplier(
                                            accessTok: widget.Axtok,
                                          ));
                                        },
                                        child: Icon(Icons.add_rounded)),
                                    // suffix: IconButton(
                                    //   icon: Icon(Icons.add_rounded),
                                    //   onPressed: () {
                                    //     _showBottomSheet();
                                    //   },
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorTheme.m_blue_mpauko_zaidi,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            ColorTheme.m_blue.withOpacity(0.8),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  maxSuggestionsInViewPort: 6,
                                  itemHeight: 50,
                                  suggestionState: SuggestionState.enabled,
                                  suggestionsDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // initialValue: items[1]['name'],
                                  onTap: (value) {
                                    // getSupplier();
                                    setState(() {
                                      _selectedItem = value!;

                                      int selectedIndex = items.indexWhere(
                                          (item) => item["name"] == value);
                                      if (selectedIndex != -1) {
                                        // Make sure the selected index is valid
                                        selectedSupplierId =
                                            supplierIds[selectedIndex];

                                        print(
                                            "Selected product Index: $selectedIndex");
                                        print(
                                            "Selected product ID: $selectedSupplierId");
                                      }
                                    });

                                    print("list of : ${supplierIds}");

                                    print(value);
                                    print(items
                                        .map((item) => item["name"])
                                        .toList());
                                  },
                                  suggestions: items
                                      .map<String>(
                                          (item) => item["name"] as String)
                                      .toList()
                                  // .map((e) =>
                                  //     SearchFieldListItem(e,
                                  //         child: Text(e)))
                                  // .toList(),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      _selectedItem != null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mode of payment",
                                    style: kInfoRegularTextStyle,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    // alignment: WrapAlignment.start,
                                    // spacing: 8.0,
                                    children: [
                                      FilterChip(
                                        backgroundColor:
                                            ColorTheme.m_blue_mpauko_zaidi,
                                        label: Text(
                                          'Cash',
                                          style: TextStyle(
                                              color: _value == "CA"
                                                  ? ColorTheme
                                                      .m_blue_mpauko_zaidi_zaidi
                                                  : ColorTheme.m_blue),
                                        ),
                                        onSelected: (val) {
                                          _handleValueChanged("CA");
                                        },
                                        checkmarkColor: ColorTheme.m_white,
                                        selected: _value == "CA",
                                        selectedColor: ColorTheme.m_blue,
                                      ),
                                      SizedBox(width: 10),
                                      FilterChip(
                                        backgroundColor:
                                            ColorTheme.m_blue_mpauko_zaidi,
                                        label: Text(
                                          'Check',
                                          style: TextStyle(
                                              color: _value == "CH"
                                                  ? ColorTheme
                                                      .m_blue_mpauko_zaidi_zaidi
                                                  : ColorTheme.m_blue),
                                        ),
                                        onSelected: (val) {
                                          _handleValueChanged("CH");
                                        },
                                        selected: _value == "CH",
                                        showCheckmark: true,
                                        checkmarkColor: ColorTheme.m_white,
                                        selectedColor: ColorTheme.m_blue,
                                      ),
                                      SizedBox(width: 10),
                                      FilterChip(
                                        backgroundColor:
                                            ColorTheme.m_blue_mpauko_zaidi,
                                        label: Text(
                                          'Credit',
                                          style: TextStyle(
                                              color: _value == "CR"
                                                  ? ColorTheme
                                                      .m_blue_mpauko_zaidi_zaidi
                                                  : ColorTheme.m_blue),
                                        ),
                                        onSelected: (val) {
                                          _handleValueChanged("CR");
                                        },
                                        selected: _value == "CR",
                                        checkmarkColor: ColorTheme.m_white,
                                        selectedColor: ColorTheme.m_blue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 12, 16, 8),
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
                            child: GestureDetector(
                              onTap: () {
                                getProducts();
                              },
                              child: SearchField(
                                  hint: 'Search Products',
                                  searchInputDecoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          _showBottomSheet(ProductCat(Axtok: widget.Axtok,));
                                        },
                                        child: Icon(Icons.add_rounded)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorTheme.m_blue_mpauko_zaidi,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color:
                                            ColorTheme.m_blue.withOpacity(0.8),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  maxSuggestionsInViewPort: 6,
                                  itemHeight: 50,
                                  suggestionState: SuggestionState.enabled,
                                  suggestionsDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // initialValue: items[1]['name'],
                                  onTap: (value) {
                                    getProducts();
                                    setState(() {
                                      _selectedItem = value!;

                                      int selectedIndex = products.indexWhere(
                                          (item) => item["name"] == value);
                                      if (selectedIndex != -1) {
                                        // Make sure the selected index is valid
                                        selectedProductId =
                                            productIds[selectedIndex];

                                        print(
                                            "Selected product Index: $selectedIndex");
                                        print(
                                            "Selected product ID: $selectedProductId");
                                      }
                                    });

                                    print("list of : ${productIds}");

                                    print(value);
                                    print(products
                                        .map((item) => item["name"])
                                        .toList());
                                  },
                                  suggestions: products
                                      .map<String>(
                                          (item) => item["name"] as String)
                                      .toList()
                                  // .map((e) =>
                                  //     SearchFieldListItem(e,
                                  //         child: Text(e)))
                                  // .toList(),
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
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return "Fill in amount";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Amount Format";
                            },
                            controller: amountC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.adobe_sharp,
                              ),
                              labelText: "Unit Price",
                              hintText: "Ex: 10,000.00",
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
                                return "Fill in quantity";
                              }
                              RegExp regExp = new RegExp(r'^[0-9]+$');
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid quantity Format";
                            },
                            controller: quantityC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.numbers,
                              ),
                              labelText: "Quantity",
                              hintText: "Ex: 7",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                            ),
                          ),
                        ),
                      ),

                      TextButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime(2049, 6, 7),
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                gdate = date;
                              });
                            }, currentTime: DateTime.now());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: ColorTheme.m_blue_mpauko_zaidi,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(gdate == null ? "" : '$gdate',
                                          style: kBodyTextStyle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Pick Date',
                                          style: kBodyRegularTextStyle),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),

                      success == true
                          ? circularLoader()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 25.0),
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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

                                    _purchasedadd();
                                    setState(() {
                                      success = true;
                                      // successErr = true;
                                    });
                                    if (showsnack == true)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Sale added (${fullnameC.text})",
                                            style: TextStyle(
                                                color: ColorTheme.m_blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        backgroundColor:
                                            ColorTheme.m_blue_mpauko_zaidi,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        elevation: 30,
                                        duration: Duration(milliseconds: 2000),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Opps!, parhaps check your internet connection",
                                            style: TextStyle(
                                                color: ColorTheme.m_white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 103, 13, 7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        elevation: 30,
                                        duration: Duration(milliseconds: 2000),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Opps!, parhaps check your internet connection",
                                            style: TextStyle(
                                                color: ColorTheme.m_white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 103, 13, 7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        elevation: 30,
                                        duration: Duration(milliseconds: 2000),
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
                              )),

                      // success ==false ?
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

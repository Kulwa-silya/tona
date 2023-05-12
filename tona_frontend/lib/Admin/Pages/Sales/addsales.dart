import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Products/productsCategory.dart';
import 'package:machafuapp/Admin/Pages/Sales/addsoldProducts.dart';
import 'package:machafuapp/Admin/Pages/Sales/salesHome.dart';
import 'package:machafuapp/Admin/Shared/CustomDateTimePicker.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Shared/myTextFormField.dart';
import '../../consts/colorTheme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddSales extends StatefulWidget {
  int? pid;
  String? titl, axxtok;
  AddSales({this.pid, required this.axxtok, this.titl, Key? key})
      : super(key: key);

  @override
  State<AddSales> createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales> {
  TextEditingController cnameC = new TextEditingController();
  TextEditingController descC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();

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

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });

    print(" tokeni $accesTok");
    return stringValue;
  }

  @override
  void initState() {
    getAccessToken();

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

  final picker = ImagePicker();

  Future<void> uploadImage() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile!.path);
        imgName = pickedFile!.name;
        _isImageSelected = true;
      });
    }
  }

  Future _salesadd() async {
    try {
      final res = await http
          .post(Uri.parse("https://tona-production.up.railway.app/sales/sale/"),
              headers: {
                HttpHeaders.authorizationHeader: "JWT $accesTok",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                "customer_name": cnameC.text,
                "phone_number": "+255${phoneC.text}",
                "description": descC.text,
                "date":
                    gdate == null ? DateTime.now().toString() : gdate.toString()
              }))
          .then((value) async {
        jsonre = jsonDecode(value.body);
        setState(() {
          id = jsonre['id'];
          print("id ni: $id");
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
                builder: (BuildContext context) => SalesHome(
                      Axtok: widget.axxtok!,
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
                        child: Text("New Sale", style: kHeading2TextStyle),
                      ),
                      SizedBox(height: 20),

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
                                return "Fill in Customer name";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Customer Name Format";
                            },
                            controller: cnameC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.adobe_sharp,
                              ),
                              labelText: "Customer Name",
                              hintText: "Ex: Norman Mushi",
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
                                return "Fill in Description ";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Description  Format";
                            },
                            controller: descC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.description_rounded,
                              ),
                              labelText: "Description ",
                              hintText: "Ex: Type, form, condition",
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
                      // Container(
                      //   child: SfDateRangePicker(
                      //     initialSelectedRange: PickerDateRange(
                      //       DateTime.now().subtract(Duration(days: 5)),
                      //       DateTime.now().add(Duration(days: 5)),
                      //     ),
                      //     selectionMode: DateRangePickerSelectionMode.range,
                      //     // dateFormat: 'dd/MM/yyyy',
                      //     onSelectionChanged:
                      //         (DateRangePickerSelectionChangedArgs args) {
                      //       // Handle the selection change event here
                      //     },
                      //   ),
                      // ),

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

                                    _salesadd().then((value) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AddSoldProd(
                                              saleId: id,
                                              title: "Add Sold Product!",
                                              showdropdown: true,
                                              date: "null",
                                              accessTok: accesTok,
                                              salename:
                                                  "Sale to ${cnameC.text} for $dayOfWeek ${gdate == null ? DateTime.now().toString().substring(0, 16) : gdate.toString().substring(0, 16)}",
                                            );
                                          });
                                    });
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
                                            "Sale added (${cnameC.text})",
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

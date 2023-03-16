import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Shared/myTextFormField.dart';
import '../../consts/colorTheme.dart';

class Addproduct extends StatefulWidget {
  int? pid;
  String? titl;
  Addproduct({this.pid, this.titl, Key? key}) : super(key: key);

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
    super.initState();
  }

  final picker = ImagePicker();

  // Future<void> uploadImage() async {
  //   pickedFile = await picker.pickImage(source: ImageSource.gallery);
  // }

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

  void _productadd() async {
    try {
      final res = await http
          .post(
              Uri.parse(
                  "https://tona-production-8ea1.up.railway.app/store/products/"),
              headers: {
                HttpHeaders.authorizationHeader: "JWT $accesTok",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                "title": titleC.text,
                "description": descC.text,
                "inventory": int.parse(inveC.text),
                "unit_price": unitPC.text,
                "collection": widget.pid,
                "images": null
              }))
          .then((value) async {
        jsonre = jsonDecode(value.body);
        setState(() {
          id = jsonre['id'];
          print("id ni: $id");
          success = false;
        });
        print(pickedFile!.path);

        if (pickedFile != null) {
          var request = http.MultipartRequest(
              'POST',
              Uri.parse(
                  'https://tona-production-8ea1.up.railway.app/store/products/$id/images/'));
          request.headers['Authorization'] = 'JWT $accesTok';
          request.files.add(
              await http.MultipartFile.fromPath('image', pickedFile!.path));
          var response = await request.send();
          if (response.statusCode == 201) {
            print("cool");
          } else {
            print("insert image");
          }
        }

        print("responsi ni: $jsonre");

        print("success");
      });
    } catch (e) {
      setState(() {
        success = false;
        successErr = true;
      });
    }

    print(success);
  }

  bool saveAttempt = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => Products(
                      id: widget.pid,
                      title: widget.titl,
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
                          "New Product",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                          onPressed: () {
                            uploadImage();
                          },

                          style: ElevatedButton.styleFrom(
                                  primary: ColorTheme.m_blue_mpauko,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                ),
                          child: Text("Pick image")),
                      _isImageSelected == false
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 600,
                                  height: 350,
                                  child: ExtendedImage.file(_imageFile!)),
                            ),

//                           if (_isImageSelected) {
//   return Image.file(_imageFile!);
// } else {
//   return Text('No image selected');
// }

                      Text(imgName),

                      mytextField(
                          contro: titleC,
                          kybType: TextInputType.text,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Taa",
                          hintLebel: "Product Name",
                          validateText: "Fill in product name",
                          finalvalidateText: "Invalid Product Name Format",
                          icodata: Icons.adobe_sharp,
                          // inputFormatter: [
                          //   FilteringTextInputFormatter.allow(
                          //       new RegExp('[a-zA-Z]'))
                          // ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                              "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"),
                      mytextField(
                          contro: descC,
                          kybType: TextInputType.text,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: Maelezo juu ya bidhaa",
                          hintLebel: "Description",
                          validateText: "Fill in product Description",
                          finalvalidateText: "Invalid Description Format",
                          icodata: Icons.description,
                          // inputFormatter: [
                          //   FilteringTextInputFormatter.allow(
                          //       new RegExp('[a-zA-Z]'))
                          // ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: DropdownButton(
                      //     dropdownColor: ColorTheme.m_white,
                      //     style: TextStyle(color: ColorTheme.m_blue),
                      //     hint: Text("Select"),
                      //     underline: Container(
                      //       height: 2,
                      //       color: ColorTheme.m_blue,
                      //     ),
                      //     value: dropdownvalue,
                      //     icon: Icon(
                      //       Icons.keyboard_arrow_down,
                      //       color: ColorTheme.m_blue,
                      //     ),
                      //     items: items.map((String items) {
                      //       return DropdownMenuItem(
                      //         value: items,
                      //         child: Text(items),
                      //       );
                      //     }).toList(),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         dropdownvalue = newValue!;
                      //       });
                      //     },
                      //   ),
                      // ),
                      mytextField(
                          contro: inveC,
                          kybType: TextInputType.number,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 2",
                          hintLebel: "Inventory",
                          validateText: "Fill Inventory Number",
                          finalvalidateText: "Invalid Inventory Format",
                          icodata: Icons.inventory,
                          // inputFormatter: [
                          //   FilteringTextInputFormatter.digitsOnly,
                          //   FilteringTextInputFormatter.deny(
                          //       new RegExp(r"\s\b|\b\s"))
                          // ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      mytextField(
                          kybType: TextInputType.number,
                          contro: unitPC,
                          autoval: AutovalidateMode.onUserInteraction,
                          hint: "Ex: 500",
                          hintLebel: "Unit Price",
                          validateText: "Fill Unit Price",
                          finalvalidateText: "Invalid unit price Format",
                          icodata: Icons.monetization_on,
                          // inputFormatter: [
                          //   FilteringTextInputFormatter.digitsOnly,
                          //   FilteringTextInputFormatter.deny(
                          //       new RegExp(r"\s\b|\b\s"))
                          // ],
                          regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      // mytextField(
                      //     contro: PricTC,
                      //     autoval: AutovalidateMode.onUserInteraction,
                      //     hint: "Ex: 535",
                      //     hintLebel: "Price with Tax",
                      //     validateText: "Fill in your Price with Tax",
                      //     finalvalidateText: "Invalid Price with Tax Format",
                      //     icodata: Icons.monetization_on_outlined,
                      //     inputFormatter: [
                      //       FilteringTextInputFormatter.digitsOnly,
                      //       FilteringTextInputFormatter.deny(
                      //           new RegExp(r"\s\b|\b\s"))
                      //     ],
                      //     regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),
                      // mytextField(
                      //     contro: CollectionC,
                      //     autoval: AutovalidateMode.onUserInteraction,
                      //     hint: "Ex: 1",
                      //     hintLebel: "Collections",
                      //     validateText: "Fill in your Collection",
                      //     finalvalidateText: "Invalid Collection Format",
                      //     icodata: Icons.collections_bookmark,
                      //     inputFormatter: [
                      //       FilteringTextInputFormatter.digitsOnly,
                      //       FilteringTextInputFormatter.deny(
                      //           new RegExp(r"\s\b|\b\s"))
                      //     ],
                      //     regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]"),

                      success == true
                          ? CircularProgressIndicator(
                  strokeWidth: 1,
                  color: ColorTheme.m_blue,
                )
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

                                    _productadd();
                                    setState(() {
                                      success = true;
                                      // successErr = true;
                                    });
                                    if (success == true)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Product added (${titleC.text})",
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

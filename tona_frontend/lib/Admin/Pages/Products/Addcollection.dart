import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Products/productsCategory.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Shared/myTextFormField.dart';
import '../../consts/colorTheme.dart';

class AddCollection extends StatefulWidget {
  int? pid;
  String? titl;
  bool hideBack = false;
  AddCollection({this.pid, this.titl, required this.hideBack, Key? key})
      : super(key: key);

  @override
  State<AddCollection> createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {
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
                  "https://tona-production.up.railway.app/store/collections/"),
              headers: {
                HttpHeaders.authorizationHeader: "JWT $accesTok",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                "title": titleC.text,
              }))
          .then((value) async {
        setState(() {
          success = false;
        });
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
                builder: (BuildContext context) => ProductCat(
                      Axtok: accesTok!,
                    )));
          },
          child: widget.hideBack == true
              ? SizedBox.shrink()
              : Padding(
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
                        child:
                            Text("New Collection", style: kHeading2TextStyle),
                      ),
                      SizedBox(height: 20),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (emailValue) {
                          if (emailValue!.isEmpty) {
                            return "Fill in Collection name";
                          }
                          RegExp regExp = new RegExp(
                              "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                  "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                          if (regExp.hasMatch(emailValue)) {
                            return null;
                          }
                          return "Invalid Collection Name Format";
                        },
                        controller: titleC,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.adobe_sharp,
                          ),
                          labelText: "Collection Name",
                          hintText: "Ex: Electronics",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorTheme.m_blue),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                                            "Collection added (${titleC.text})",
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

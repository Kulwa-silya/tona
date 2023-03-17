import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Users/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts/colorTheme.dart';
import 'myTextFormField.dart';

class myEditordialog extends StatefulWidget {
  String? data1;
  int? id;
  String? data2;
  bool? islod;
  String? data3;
  String? data4, data5;
  int? imageId, collId;
  String? heading, collname;
  String? widget, image, whatpart;
  String? accesstok;

  myEditordialog(
      {Key? key,
      this.data1,
      this.id,
      this.collname,
      this.heading,
      this.data2,
      required this.whatpart,
      this.image,
      this.collId,
      this.imageId,
      this.accesstok,
      required this.islod,
      required this.widget,
      this.data3,
      this.data4,
      this.data5})
      : super(key: key);

  @override
  State<myEditordialog> createState() => _mydialogState();
}

class _mydialogState extends State<myEditordialog> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController utype = new TextEditingController();
  TextEditingController title = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  TextEditingController inventory = new TextEditingController();
  TextEditingController unitprice = new TextEditingController();
  var collectionn;

  final formkey = GlobalKey<FormState>();

  XFile? pickedFile;

  File? _imageFile;

  bool _isImageSelected = false;

  String? imgName;

  final picker = ImagePicker();

  String? accesTok;

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

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });

    print(" tokeni $accesTok");
    return stringValue;
  }

  updateProducts() async {
    final responseprod = await http
        .patch(
            Uri.parse(
                "https://tona-production-8ea1.up.railway.app/store/products/${widget.id}/"),
            headers: {
              HttpHeaders.authorizationHeader: "JWT $accesTok",
              "Accept": "application/json",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "title": title.text,
              "description": desc.text,
              "inventory": int.parse(inventory.text),
              "unit_price": unitprice.text,
              "collection": widget.collId,
              "images": null

              // "title": "heyyy",
              // "description": "desc.text",
            }))
        .then((value) async {
      if (pickedFile != null) {
        var request = http.MultipartRequest(
            'PATCH',
            Uri.parse(
                'https://tona-production-8ea1.up.railway.app/store/products/${widget.id}/images/${widget.imageId}/'));
        request.headers['Authorization'] = 'JWT ${widget.accesstok}';
        request.files
            .add(await http.MultipartFile.fromPath('image', pickedFile!.path));
        var response = await request.send();
        if (response.statusCode == 200) {
          print("cool");
        } else {
          print("not cool");
        }
      }
    });

    print(responseprod);
  }

  Future updateUser() async {
    final response = await http
        .patch(
            Uri.parse(
                "https://tona-production-8ea1.up.railway.app/tona_users/users/${widget.id}/"),
            headers: {
              HttpHeaders.authorizationHeader: "JWT $accesTok",
              "Accept": "application/json",
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              "first_name": fname.text,
              "last_name": lname.text,
              "user_type": int.parse(utype.text)

              // "first_name": "fname.text",
              // "last_name": "lname.text 2222ddd",
              // "user_type": 2,
            }))
        .then((value) async {
      print(value);
    });

    print("res ni $response");
  }

  @override
  void initState() {
    print(widget.imageId);
    getAccessToken();
    title = new TextEditingController(text: widget.data1);
    desc = new TextEditingController(text: widget.data2);
    inventory = new TextEditingController(text: widget.data3);
    unitprice = new TextEditingController(text: widget.data4);
    fname = new TextEditingController(text: widget.data1);
    lname = new TextEditingController(text: widget.data2);
    utype = new TextEditingController(text: widget.data3);
  }

  bool saveAttempt = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 8),
                      child: Center(
                        child: Text(
                          "${widget.heading}",
                          style: TextStyle(
                              color: ColorTheme.m_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),

                    // //userdialogtextfields
                    widget.widget == "adduser"
                        ? mytextField(
                            kybType: TextInputType.emailAddress,
                            contro: fname,
                            // value: widget.data1,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "Fill the new Username",
                            hintLebel: "${widget.data1.toString()}",
                            validateText: "Fill in the Username",
                            finalvalidateText: "Invalid UserName Format",
                            icodata: Icons.person,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+")
                        : SizedBox.shrink(),
                    widget.widget == "adduser"
                        ? mytextField(
                            kybType: TextInputType.emailAddress,
                            contro: lname,
                            // value: widget.data2,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "fill the new email",
                            hintLebel: "${widget.data2}",
                            validateText: "Fill in your email",
                            finalvalidateText: "Invalid Email Format",
                            icodata: Icons.email,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+")
                        : SizedBox.shrink(),
                    widget.widget == "adduser"
                        ? mytextField(
                            kybType: TextInputType.emailAddress,
                            contro: utype,
                            // value: widget.data3,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "fill the new phone",
                            hintLebel: "${widget.data3} ${widget.id}",
                            validateText: "Fill in your phone",
                            finalvalidateText: "Invalid Phone Format",
                            icodata: Icons.email,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+")
                        : SizedBox.shrink(),

                    //products dialogs fields
                    widget.widget == "addproduct"
                        ? widget.image != null
                            ? GestureDetector(
                                onTap: () {
                                  uploadImage();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: _isImageSelected == true
                                        ? Image.file(_imageFile!)
                                        : FadeInImage.assetNetwork(
                                            image: widget.image!,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 200,
                                            placeholder:
                                                'assets/images/image_1.png',
                                            imageErrorBuilder: (BuildContext?
                                                        context,
                                                    Object? error,
                                                    StackTrace? stackTrace) =>
                                                Image.asset(
                                              'assets/images/image_1.png',
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExtendedImage.asset(
                                    fit: BoxFit.cover,
                                    "assets/images/image_1.png"),
                              )
                        : SizedBox.shrink(),
                    widget.widget == "addproduct"
                        ? mytextField(
                            kybType: TextInputType.text,
                            contro: title,
                            // value: widget.data1,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "Fill the new title",
                            hintLebel: "Product Name",
                            validateText: "Fill in the title",
                            finalvalidateText: "Invalid title format",
                            icodata: Icons.person,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]")
                        : SizedBox.shrink(),

                    widget.widget == "addproduct"
                        ? mytextField(
                            kybType: TextInputType.text,
                            contro: desc,
                            // value: widget.data2,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "Fill the new description",
                            hintLebel: "Description",
                            validateText: "Fill in the description",
                            finalvalidateText: "Invalid description format",
                            icodata: Icons.person,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]")
                        : SizedBox.shrink(),
                    widget.widget == "addproduct"
                        ? mytextField(
                            kybType: TextInputType.number,
                            contro: unitprice,
                            // value: widget.data3,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "Fill the new unitprice",
                            hintLebel: "Unit Price",
                            validateText: "Fill in the unitprice",
                            finalvalidateText: "Invalid unitprice format",
                            icodata: Icons.person,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]")
                        : SizedBox.shrink(),
                    widget.widget == "addproduct"
                        ? mytextField(
                            kybType: TextInputType.number,
                            contro: inventory,
                            // value: widget.data4,
                            autoval: AutovalidateMode.onUserInteraction,
                            hint: "Fill the new inventory number",
                            hintLebel: "Product Count",
                            validateText: "Fill in the inventory number",
                            finalvalidateText: "Invalid inventory format",
                            icodata: Icons.person,
                            // inputFormatter: [
                            //   FilteringTextInputFormatter.deny(
                            //       new RegExp(r"\s\b|\b\s"))
                            // ],
                            regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]")
                        : SizedBox.shrink(),
                    // widget.widget == "addproduct"
                    // ? mytextField(
                    //     kybType: TextInputType.text,
                    //     contro: desc,
                    //     value: widget.data1,
                    //     autoval: AutovalidateMode.onUserInteraction,
                    //     hint: "Fill the new description",
                    //     hintLebel: "${widget.data1.toString()}",
                    //     validateText: "Fill in the description",
                    //     finalvalidateText: "Invalid description format",
                    //     icodata: Icons.person,
                    //     // inputFormatter: [
                    //     //   FilteringTextInputFormatter.deny(
                    //     //       new RegExp(r"\s\b|\b\s"))
                    //     // ],
                    //     regExpn: "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                    //         "\\@" +
                    //         "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                    //         "(" +
                    //         "\\." +
                    //         "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                    //         ")+")
                    // : SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text(
                              'Close',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorTheme.m_red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Update',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
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

                                  if (widget.whatpart == "user") {
                                    await updateUser();
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserConfig()));
                                  } else if (widget.whatpart == "product") {
                                    await updateProducts();
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => Products(
                                                  id: widget.collId,
                                                  title: widget.collname,
                                                )));
                                  }

                                  // setState(() {
                                  //   widget.islod = true;
                                  // });

// await   Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => Products(id: widget.id,)),
//               (Route<dynamic> route) => false,
//             );
//                                 }
                                }
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

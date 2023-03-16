import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages/Users/view.dart';
import '../consts/colorTheme.dart';
import 'myTextFormField.dart';

class myDeletedialog extends StatefulWidget {
  int? pid, collId;

  String? tit, email, collname, whatpart;

  bool? isloading;

  myDeletedialog(
      {Key? key,
      required this.pid,
      this.isloading,
      this.collId,
      required this.whatpart,
      this.collname,
      required this.email,
      required this.tit})
      : super(key: key);

  @override
  State<myDeletedialog> createState() => _mydialogState();
}

class _mydialogState extends State<myDeletedialog> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool saveAttempt = false;

  String? accesTok;

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

  deleteProducts() async {
    final response = await http.delete(
      Uri.parse(
          "https://tona-production-8ea1.up.railway.app/store/products/${widget.pid}/"),
      headers: {
        HttpHeaders.authorizationHeader: "JWT $accesTok",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) => {print("success")});

    print(response);
  }

  deleteUser() async {
    final response = await http.delete(
      Uri.parse(
          "http://tona-production-8ea1.up.railway.app/tona_users/users/${widget.pid}/"),
      headers: {
        HttpHeaders.authorizationHeader: "JWT $accesTok",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) => {print("success")});

    print(response);
  }

  @override
  void initState() {
    getAccessToken();
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
                padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 8),
                child: Center(
                  child: Text(
                    "Caution!",
                    style: TextStyle(
                        color: ColorTheme.m_blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Are you sure you want to delete,"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.pid} ?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorTheme.m_grey),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          )
                        ],
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
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Yeah',
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

                        if (widget.whatpart == "product") {
                          deleteProducts();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Products(
                                        id: widget.collId,
                                        title: widget.collname,
                                      )));
                        } else if (widget.whatpart == "user") {
                          deleteUser();
                          Navigator.pop(context);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => UserConfig()));
                        }

                        // await Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => Products(
                        //             id: widget.pid,
                        //           )),
                        //   (Route<dynamic> route) => false,
                        // );
                      },
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

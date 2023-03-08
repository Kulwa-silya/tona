import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../consts/colorTheme.dart';
import 'myTextFormField.dart';

class myDeletedialog extends StatefulWidget {
  int pid;

  String tit, email;

  myDeletedialog(
      {Key? key, required this.pid, required this.email, required this.tit})
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

  deleteProducts() async {
    final response = await http.delete(
      Uri.parse(
          "https://tona-production-8ea1.up.railway.app/store/products/${widget.pid}/"),
      headers: {
        HttpHeaders.authorizationHeader:
            "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjc4Mzc0MzM0LCJqdGkiOiJhNDBhZjgwZGZhZmY0NmI5YWNmMDFlY2Q0ZTNmODUxYyIsInVzZXJfaWQiOjF9.vxtAsg9pOxqDD12LpoehBk_KlB54C3Qrrwwn-VZwPK4",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) => {print("success")});

    print(response);
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
                        deleteProducts();
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

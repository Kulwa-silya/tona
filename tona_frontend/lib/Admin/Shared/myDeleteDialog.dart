import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts/colorTheme.dart';
import 'myTextFormField.dart';

class myDeletedialog extends StatefulWidget {
  String email;
  String uname;

  myDeletedialog({Key? key, required this.email, required this.uname})
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you sure you want to delete "),
                  Text(
                    "${widget.uname} ?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: ColorTheme.m_grey),
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

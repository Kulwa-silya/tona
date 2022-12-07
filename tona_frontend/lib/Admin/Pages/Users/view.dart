import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Users/Registration/registerUsers.dart';
import 'package:machafuapp/Admin/Pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Shared/getTokens.dart';
import '../../Shared/myDeleteDialog.dart';
import '../../Shared/myEditorDialog.dart';
import '../../consts/colorTheme.dart';

class UserConfig extends StatefulWidget {
  String acctok;
  UserConfig({Key? key, required this.acctok}) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  String? refreshTok;

  String? accesTok;

  String? stringValue;

  List<dynamic>? userdata;

  List<String>? emaild;

  List<int>? Id;

  List<String>? uname;

  @override
  void initState() {
    getAccessToken();
    // getRefreshToken();
    fetchInfo();
    // getUsers();
    super.initState();
  }

  List userdatas = [];

  // getAccessToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return String
  //   String? stringValue = prefs.getString('accesstoken');
  //   setState(() {
  //     accesTok = stringValue;
  //   });
  //   return stringValue;
  // }

  Future fetchInfo() async {
    final response = await http.get(
        Uri.parse('https://tona-production.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader: "JWT ${widget.acctok}",
        });
    final jsonresponse = json.decode(response.body);

    return jsonresponse;
  }

  void editdialog() {
    AlertDialog(
      title: Text("Success"),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      actionsOverflowButtonSpacing: 20,
      actions: [
        ElevatedButton(onPressed: () {}, child: Text("Back")),
        ElevatedButton(onPressed: () {}, child: Text("Next")),
      ],
      content: Text("Saved successfully"),
    );
  }

//   Future<UsersDataModel> fetchInfo() async {

//     final response = await http.get(
//         Uri.parse('https://tona-production.up.railway.app/auth/users/'),
//         headers: {
//           HttpHeaders.authorizationHeader: "JWT ${widget.acctok}",
//         });
//     final jsonresponse = json.decode(response.body);

//     // dynamic l = json.decode(response.body);
//     // List<UsersDataModel> posts = List<UsersDataModel>.from(
//     //     l.map((model) => UsersDataModel.fromJson(model)));

//     // print(response.body);

// // userdatas.add(value)
//     // List<dynamic> userlist = [];
//     // jsonresponse.forEach((s) => userlist.add(s["email"]));

//     // setState(() {
//     //   userdata = userlist;
//     // });

//     // final len = jsonresponse.length;

//     // for (int i = 0; i < len; i++) {
//     //   setState(() {
//     //     UsersDataModel.fromJson(jsonresponse[i]).email = emaild!;
//     //     UsersDataModel.fromJson(jsonresponse[i]).id = Id!;
//     //     UsersDataModel.fromJson(jsonresponse[i]).username = uname!;
//     //   });
//     // }
//     // print(UsersDataModel.fromJson(jsonresponse[2]).email);
//     return UsersDataModel.fromJson(jsonresponse[2]);
//     // return jsonresponse;
//   }

  getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('refreshtoken');

    setState(() {
      refreshTok = stringValue;
    });
    return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => DashBoard()));
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
        actions: [
          // accesTok == null?
          // CircularProgressIndicator()
          // :
          // Text(
          //   accesTok!,
          //   style: TextStyle(color: Colors.black),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RegisterUsers(axxton: widget.acctok)));
              },
              child: Center(
                child: Text(
                  "New User",
                  style: TextStyle(
                      color: ColorTheme.m_blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: ColorTheme.m_white,
      ),
      body: Container(
        color: ColorTheme.m_white,
        child: FutureBuilder(
            future: fetchInfo(),
            builder: (contx, AsyncSnapshot snap) {
              return !snap.hasData
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorTheme.m_blue,
                      ),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (cnt, index) {
                        String? email = snap.data[index]['email'];
                        String? uname = snap.data[index]['username'];
                        int? id = snap.data[index]['id'];

                        return ExpansionTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                height: 50,
                                width: 50,
                                color: ColorTheme.m_blue,
                              )),
                          title: Text(
                            email!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorTheme.m_grey),
                          ),
                          subtitle: Text(
                            uname!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: ColorTheme.m_blue),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          myEditordialog(
                                            email: email,
                                            uname: uname,
                                          ));
                                },
                                icon: Icon(Icons.edit_outlined),
                                color: ColorTheme.m_blue,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          myDeletedialog(
                                            email: email,
                                            uname: uname,
                                          ));
                                },
                                icon: Icon(Icons.delete_outline_outlined),
                                color: ColorTheme.m_red,
                              ),
                            ],
                          ),

                          children: [Text(id.toString())],

                          // title: Text(snap.data.email),
                          // subtitle: Text(snap.data.username),
                        );
                      });

              // ListView(
              //     children: userdata!.map((dat) {
              //     return Container(
              //       child: Text(dat.email!),
              //       margin: EdgeInsets.all(5),
              //       padding: EdgeInsets.all(15),
              //       color: Colors.green[100],
              //     );
              //   }).toList());
            }),
      ),
    );
  }
}

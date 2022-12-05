import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machafuapp/Admin/Pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Admin/Pages/users/Registration/registerUsers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/getUserList.dart';
import '../../consts/colorTheme.dart';

class UserConfig extends StatefulWidget {
  const UserConfig({Key? key}) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  String? refreshTok;

  String? accesTok;

  String? stringValue;

  List<dynamic>? userdata;

  @override
  void initState() {
    getAccessToken();
    getRefreshToken();
    fetchInfo();
    // getUsers();
    super.initState();
  }

  Future<UsersDataModel> fetchInfo() async {
    final response = await http.get(
        Uri.parse('https://tona-production.up.railway.app/auth/users/'),
        headers: {
          HttpHeaders.authorizationHeader: "JWT $accesTok",
        });
    final jsonresponse = json.decode(response.body);

    print(response.body);

    // List<dynamic> userlist = [];
    // jsonresponse.forEach((s) => userlist.add(s["email"]));

    // setState(() {
    //   userdata = userlist;
    // });

    final len = jsonresponse.length;
    print(len);
    return UsersDataModel.fromJson(jsonresponse[3]);
  }

  // Future getUsers() async {
  //   print("JWT $accesTok");
  //   final resp = await http.get(
  //       Uri.parse('https://tona-production.up.railway.app/auth/users/'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "JWT $accesTok",
  //       });

  //   Map<String, dynamic> map = json.decode(resp.body);

  //   // print(map[0]['email']);

  //   // setState(() {
  //   //   users = userdata;
  //   // });
  //   return map;
  // }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    accesTok = prefs.getString('accesstoken');

    // setState(() {
    //   accesTok = stringValue;
    // });

    print(accesTok);
    return accesTok;
  }

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
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    color: ColorTheme.m_blue,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      child: Icon(
                        Icons.arrow_back_ios,
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterUsers()));
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
                      itemCount: 4,
                      itemBuilder: (cnt, index) {
                        return ListTile(
                          title: Text(snap.data.email),
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

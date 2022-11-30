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

  @override
  void initState() {
    getAccessToken();
    getRefreshToken();
    getUsers();
    super.initState();
  }

  Future getUsers() async {
    print("JWT $accesTok");
    final resp = await http
        .get(Uri.parse('https://tona-production.up.railway.app/auth/users/'), headers: {
      HttpHeaders.authorizationHeader: "JWT $accesTok",
    });

    print(resp.body);

   List<UserModel> users = (json.decode(resp.body) as List)
      .map((data) => UserModel.fromJson(data))
      .toList();
   
    return users;
  }

  

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');

    setState(() {
      accesTok = stringValue;
    });

    print(accesTok);
    return stringValue;
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
          future: getUsers(),
          builder: (contx, AsyncSnapshot snap) {
            
            return 
            !snap.hasData
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorTheme.m_blue,
                    ),
                  )
                : ListView.builder(
                    itemCount: 5,
                    itemBuilder: (cxt, i) {
                      return ListTile(
                        title: Text(snap.data()[i]['email']),
                        trailing: Icon(Icons.edit),
                      );
                    });
          },
        ),
      ),
    );
  }
}

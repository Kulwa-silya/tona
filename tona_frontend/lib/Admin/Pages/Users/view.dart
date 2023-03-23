import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Users/Registration/registerUsers.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Admin/Shared/myDeleteDialog.dart';
import 'package:machafuapp/Admin/Shared/myEditorDialog.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/userProvider.dart';
import '../../Models/getUserList.dart';
import '../../consts/colorTheme.dart';
import '../../ui/shared/text_styles.dart';

class UserConfig extends StatefulWidget {
  // String acctok;
  UserConfig({
    Key? key,
  }) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  // DatabaseHelper databaseHelper = DatabaseHelper();
  UserProvider userProvider = UserProvider();

  List userList = [];

  bool isloading = false;

  List _foundUsers = [];

  var fname, lname, phone;

  fetchUserinfo() async {
    http.Response res = await userProvider.fetchInfoe(accesTok!);

    setState(() {
      isloading = false;
      userList = welcomeFromJson(res.body);
      isloading = true;
    });

    // print(accesTok);
  }

  String? refreshTok;

  String? accesTok;

  String? stringValue;

  List<dynamic>? userdata;

  List<String>? emaild;

  List<int>? Id;

  List<String>? uname;

  String? toooken;

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

  Future<void> _pullRefresh() async {
    http.Response res = await userProvider.fetchInfoe(accesTok!);

    setState(() {
      isloading = false;
      userList = welcomeFromJson(res.body);
      isloading = true;
    });
  }

  Future updateUser() async {
    try {
      final response = await http
          .patch(
              Uri.parse(
                  "http://tona-production-8ea1.up.railway.app/tona_users/users/14/"),
              headers: {
                HttpHeaders.authorizationHeader: "JWT $accesTok",
                "Accept": "application/json",
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: json.encode({
                // "first_name": fname.text,
                // "last_name": lname.text,
                // "user_type": int.parse(utype.text),

                "first_name": "fnametext",
                "last_name": "lnametext 2222ddd",
                "user_type": 2
              }))
          .then((value) async {
        print(value);
      });

      print("res ni ${response.body}");
      print("status ni ${response.statusCode}");
    } catch (e) {
      print("shida ni $e");
    }
  }

  @override
  void initState() {
    getAccessToken().then((value) {
      setState(() {
        isloading = true;
        fetchUserinfo();
        // fetchToks();
        isloading = false;
      });
    });

    // getmyToken();
    // getRefreshToken();
    // fetchInfo();
    // getUsers();
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = userList;
    } else {
      results = userList
          .where((user) => user.first_name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      isloading = true;
      _foundUsers = results;
      isloading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Navigator.pushReplacementNamed(context, '/dash');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainView()),
              (Route<dynamic> route) => false,
            );
            // Navigator.of(context)
            //     .pushNamedAndRemoveUntil('/dash', (route) => false);
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => DashBoard()));
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
                    builder: (context) => RegisterUsers(
                          fname: fname,
                          lname: lname,
                          phone: phone,
                        )));
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
      body: RefreshIndicator(
        strokeWidth: 1,
        color: ColorTheme.m_blue,
        onRefresh: _pullRefresh,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: ColorTheme.m_white,
            child:

                // String? email = snap.data[index]['email'];
                // String? uname = snap.data[index]['username'];
                // int? id = snap.data[index]['id'];
                isloading == true
                    ? SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Container(
                                  height: 55,
                                  color: ColorTheme.m_white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      onChanged: (value) => _runFilter(value),
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w300),
                                        suffixIcon: Icon(
                                          Icons.search,
                                          color: ColorTheme.m_blue,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: ColorTheme.m_blue,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorTheme.m_blue),
                                          borderRadius: const BorderRadius.all(
                                            const Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ...userList.map(
                              (e) {
                                setState(() {
                                  fname = e.first_name;
                                  lname = e.last_name;
                                  phone = e.phone_number;
                                });
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color:
                                          ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              e.first_name,
                                              style: kBodyRegularTextStyle,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              e.last_name,
                                              style: kBodyRegularTextStyle,
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          e.phone_number,
                                          style: kTinyBoldTextStyle,
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                // updateUser();
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        myEditordialog(
                                                            widget: "adduser",
                                                            heading:
                                                                "User Editor",
                                                            whatpart: "user",
                                                            id: e.id,
                                                            islod: isloading,
                                                            data1: e.last_name,
                                                            data2: e.first_name,
                                                            data3: e.user_type
                                                                .toString(),
                                                            data4: e
                                                                .phone_number));
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: ColorTheme.m_blue,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: (() {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        myDeletedialog(
                                                            pid: e.id,
                                                            whatpart: "user",
                                                            email: e.last_name,
                                                            tit: e.first_name));
                                              }),
                                              icon: Icon(
                                                Icons.delete,
                                                color: ColorTheme.m_red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                            //  ClipRRect(
                            //         borderRadius: BorderRadius.circular(30),
                            //         child: Container(
                            //           height: 50,
                            //           width: 50,
                            //           color: ColorTheme.m_blue,
                            //         )),
                          ],
                        ),
                      )
                    : Center(
                        child: circularLoader(),
                      )

            // children: [Text(id.toString())],

            // title: Text(snap.data.email),
            // subtitle: Text(snap.data.username),

            // ListView(
            //     children: userdata!.map((dat) {
            //     return Container(
            //       child: Text(dat.email!),
            //       margin: EdgeInsets.all(5),
            //       padding: EdgeInsets.all(15),
            //       color: Colors.green[100],
            //     );
            //   }).toList());
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Users/Registration/registerUsers.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/userProvider.dart';
import '../../Models/getUserList.dart';
import '../../consts/colorTheme.dart';

class UserConfig extends StatefulWidget {
  String acctok;
  UserConfig({Key? key, required this.acctok}) : super(key: key);

  @override
  State<UserConfig> createState() => _UserConfigState();
}

class _UserConfigState extends State<UserConfig> {
  // DatabaseHelper databaseHelper = DatabaseHelper();
  UserProvider userProvider = UserProvider();

  List userList = [];

  bool isloading = false;

  fetchUserinfo() async {
    http.Response res = await userProvider.fetchInfoe();

    setState(() {
      userList = welcomeFromJson(res.body);
    });

    // print(accesTok);
  }

  // fetchToks() {
  //   dynamic res = DatabaseHelper.instance.getTokens();

  //   print(res);
  // }

  // fetchTocken() async {
  //   dynamic res = DatabaseHelper.instance.getTokens();

  //   setState(() {
  //     tokn = Tokening.fromMap(res.body);
  //   });

  //   // print(accesTok);
  // }

  String? refreshTok;

  String? accesTok;

  String? stringValue;

  List<dynamic>? userdata;

  List<String>? emaild;

  List<int>? Id;

  List<String>? uname;

  String? toooken;

  // getmyToken() async {
  //   String tken = await token.getAccessToken();
  //   setState(() {
  //     tken = toooken!;
  //   });
  // }

  @override
  void initState() {
    setState(() {
      isloading = true;
      fetchUserinfo();
      // fetchToks();
      isloading = false;
    });

    // getmyToken();
    // getRefreshToken();
    // fetchInfo();
    // getUsers();
    super.initState();
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue;
    });
    return stringValue;
  }

  // Future fetchInfo() async {
  //   final response = await http.get(
  //       Uri.parse('https://tona-production.up.railway.app/auth/users/'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "JWT ${widget.acctok}",
  //       });
  //   final jsonresponse = json.decode(response.body);

  //   return jsonresponse;
  // }

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

  // getRefreshToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return String
  //   String? stringValue = prefs.getString('refreshtoken');

  //   setState(() {
  //     refreshTok = stringValue;
  //   });
  //   return stringValue;
  // }

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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ColorTheme.m_white,
          child:

              // String? email = snap.data[index]['email'];
              // String? uname = snap.data[index]['username'];
              // int? id = snap.data[index]['id'];
              isloading == false
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ...userList.map(
                            (e) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                    child: ListTile(
                                      title: Text(e.first_name),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: ColorTheme.m_blue,
                                          ),
                                          Icon(
                                            Icons.delete,
                                            color: ColorTheme.m_red,
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
                      child: CircularProgressIndicator(),
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
    );
  }
}

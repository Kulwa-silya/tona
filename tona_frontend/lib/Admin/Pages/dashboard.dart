import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Expenditure_and_Expenses/ExpenditureExpenses.dart';
import 'package:machafuapp/Admin/Pages/Income/Income.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Purchases/purchases.dart';
import 'package:machafuapp/Admin/Pages/Report/report.dart';
import 'package:machafuapp/Admin/Pages/Users/view.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Shared/dashboardContainer.dart';

class DashBoard extends StatefulWidget {
  // String axxtok;
  DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TextEditingController positioncontrol = TextEditingController();

  String? accesTok;

  String? refreshTok;

  @override
  void initState() {
    getAccessToken();
    getRefreshToken();

    // print(accesTok);
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
    // positioncontrol.text = position;

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ColorTheme.m_blue,
            actions: [IconButton(icon: Icon(Icons.person), onPressed: () {})],
          ),
          drawer: Drawer(
            elevation: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  'Karibu : $accesTok',
                  style: TextStyle(color: ColorTheme.m_blue),
                ),
                // Text(
                //   'Karibu : $refreshTok',
                //   style: TextStyle(color: ColorTheme.m_blue),
                // ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  trailing: Icon(Icons.link),
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/Login");
                  },
                  tileColor: ColorTheme.m_blue,
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: GridView.custom(
            
            physics: BouncingScrollPhysics(),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            childrenDelegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, '/Users');

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserConfig(
                                acctok: accesTok!,
                              )));
                    },
                    child: dashboardContainer(
                      name: "Users",
                      iconName: Icons.person,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Products()));
                    },
                    child: dashboardContainer(
                      name: "My Products",
                      iconName: Icons.airline_stops_sharp,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ExpenditureExpenses()));
                    },
                    child: dashboardContainer(
                      name: "Expenditure & Expenses",
                      iconName: Icons.airline_stops_sharp,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Income()));
                    },
                    child: dashboardContainer(
                      name: "Income",
                      iconName: Icons.input,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Purchases()));
                    },
                    child: dashboardContainer(
                      name: "Purchases",
                      iconName: Icons.webhook_outlined,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Report()));
                    },
                    child: dashboardContainer(
                      name: "Monthy Report",
                      iconName: Icons.bar_chart_outlined,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

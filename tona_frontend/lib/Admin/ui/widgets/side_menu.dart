import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Expenditure_and_Expenses/ExpenditureExpenses.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Pages/Report/report.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';

import '../../Pages/Users/view.dart';
import '../shared/colors.dart';
import '../shared/text_styles.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kTertiaryColor5,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                const Icon(
                  Icons.add_box,
                  color: kBlackColor,
                ),
                Expanded(
                  child: Text(
                    'TONA Trade',
                    style: kHeading3TextStyle,
                  ),
                )
              ],
            ),
          ),
          DrawerListTile(
            title: "Home",
            icon: Icons.home,
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => MainView()));

              //option 2

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainView()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          DrawerListTile(
            title: "Users",
            icon: Icons.card_giftcard,
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => Products()));
            },
          ),
          DrawerListTile(
            title: "Products",
            icon: Icons.transform,
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => Products()));
            },
          ),
          DrawerListTile(
            title: "Expenses & Expe",
            icon: Icons.calculate,
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => ExpenditureExpenses()));
            },
          ),
          DrawerListTile(
            title: "Settings",
            icon: Icons.settings,
            press: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => Report()));
            },
          ),
          DrawerListTile(
            title: "Logout",
            icon: Icons.logout,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: kBlackColor,
      ),
      title: Text(
        title,
        style: const TextStyle(color: kBlackColor),
      ),
    );
  }
}

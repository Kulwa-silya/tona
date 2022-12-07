import 'package:flutter/material.dart';

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
                    'tona Trade',
                    style: kHeading3TextStyle,
                  ),
                )
              ],
            ),
          ),
          DrawerListTile(
            title: "Home",
            icon: Icons.home,
            press: () {},
          ),
          DrawerListTile(
            title: "Users",
            icon: Icons.card_giftcard,
            press: () {},
          ),
          DrawerListTile(
            title: "Products",
            icon: Icons.transform,
            press: () {},
          ),
          DrawerListTile(
            title: "Expenses & Expe",
            icon: Icons.calculate,
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            icon: Icons.settings,
            press: () {},
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

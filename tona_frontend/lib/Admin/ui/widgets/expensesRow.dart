import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Expenditure_and_Expenses/ExpenditureExpenses.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/colors.dart';
import '../shared/edge_insect.dart';
import '../shared/text_styles.dart';

class ExpeRow extends StatefulWidget {
  const ExpeRow({Key? key, required this.title}) : super(key: key);

  final String title;
  // final String cardText;

  @override
  State<ExpeRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<ExpeRow> {
  String? accesTok;

  String selectd = "Choose Plan";

  @override
  void initState() {
    getAccessToken();
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: kSubtitleTextStyle.copyWith(color: kBlackColor),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ExpenditureExpenses(
            //         )));
          },
          child: Container(
            padding: kEdgeInsetsHorizontalTiny,
            height: 30,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color: kTertiaryColor5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  selectd,
                  style: kTinyBoldTextStyle.copyWith(color: kBlackColor),
                ),
                // const Icon(
                //   Icons.arrow_drop_down,
                //   color: kBlackColor,
                //   size: 20,
                // ),
                PopupMenuButton(
                    // add icon, by default "3 dot" icon
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: kBlackColor,
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Daily"),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text("Weekly"),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text("Monthly"),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        setState(() {
                          selectd = "Daily";
                        });
                        print("My account menu is selected.");
                      } else if (value == 1) {
                        setState(() {
                          selectd = "Weekly";
                        });
                        print("Settings menu is selected.");
                      } else if (value == 2) {
                        setState(() {
                          selectd = "Monthly";
                        });
                        print("Logout menu is selected.");
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/Pages/Expenditure_and_Expenses/ExpenditureExpenses.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/colors.dart';
import '../shared/edge_insect.dart';
import '../shared/text_styles.dart';

class ExpeRow extends StatefulWidget {
  const ExpeRow({Key? key, required this.title, required this.cardText})
      : super(key: key);

  final String title;
  final String cardText;

  @override
  State<ExpeRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<ExpeRow> {
  String? accesTok;

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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExpenditureExpenses(
                    )));
          },
          child: Container(
            padding: kEdgeInsetsHorizontalTiny,
            height: 30,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color: kTertiaryColor5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.cardText,
                  style: kTinyBoldTextStyle.copyWith(color: kBlackColor),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: kBlackColor,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
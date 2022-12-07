import 'package:flutter/material.dart';
import '../shared/colors.dart';
import '../shared/edge_insect.dart';
import '../shared/text_styles.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.desc,
    required this.amount,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final String desc;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kEdgeInsetsAllNormal,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kTertiaryColor5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color: kBlackColor),
            child: Icon(icon),
          ),
          Text(
            text,
            style: kBodyTextStyle.copyWith(color: kBlackColor),
          ),
          Text(
            desc,
            style: kSmallRegularTextStyle.copyWith(color: kBlackColor),
          ),
          Text(
            amount,
            style: kBodyTextStyle,
          ),
        ],
      ),
    );
  }
}

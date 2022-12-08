import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/transaction_model.dart';
import '../shared/colors.dart';
import '../shared/spacing.dart';
import '../shared/text_styles.dart';

class TransactionsCard extends StatelessWidget {
  TransactionsCard({Key? key, required this.transaction}) : super(key: key);
  final TransactionModel transaction;

  // Future fetchInfo() async {
  //   final response = await http.get(
  //       Uri.parse('https://tona-production.up.railway.app/auth/users/'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "JWT ${Accxk}",
  //       });
  //   final jsonresponse = json.decode(response.body);
  //   print(response.body);
  //   return jsonresponse;
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(
                transaction.image,
              ),
            ),
            color: kWhiteColor,
          ),
        ),
        horizontalSpaceRegular,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.title,
              style: kSubtitleTextStyle.copyWith(color: kBlackColor),
            ),
            verticalSpaceSmall,
            Text(
              transaction.description,
              style: kTinyRegularTextStyle.copyWith(color: kBlackColor),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction.amount,
              style: kSubtitleTextStyle.copyWith(color: kBlackColor),
            ),
            verticalSpaceSmall,
            Text(
              transaction.date,
              style: kSmallRegularTextStyle.copyWith(color: kBlackColor),
            ),
          ],
        ),
      ],
    );
  }
}

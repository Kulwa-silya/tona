import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/userProvider.dart';
import '../../Models/getUserList.dart';
import '../../views/main/main_view.dart';
import '../shared/colors.dart';
import '../shared/spacing.dart';
import '../shared/text_styles.dart';

class TransactionsCard extends StatefulWidget {
  TransactionsCard({Key? key}) : super(key: key);
  // final TransactionModel transaction;

  @override
  State<TransactionsCard> createState() => _TransactionsCardState();
}

class _TransactionsCardState extends State<TransactionsCard> {
  UserProvider userProvider = UserProvider();

  MainView accsstheTok = MainView();

  List userList = [];

  bool isloading = false;

  String? accesTok;

  fetchUserinfo() async {
    http.Response res = await userProvider.fetchInfoe(accesTok!);

    setState(() {
      userList = welcomeFromJson(res.body);
    });
  }

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });
    return stringValue;
  }

  @override
  void initState() {
    getAccessToken().then((value) {
      isloading = true;
      fetchUserinfo();
      isloading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...userList.map(
          (e) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 8, 8),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // image: DecorationImage(
                      //   image: AssetImage(
                      //     widget.transaction.image,
                      //   ),
                      // ),

                      color: kBlackColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.transaction.amount,
                          "${e.first_name}  ${e.last_name}",

                          style:
                              kSubtitleTextStyle.copyWith(color: kBlackColor),
                        ),
                        verticalSpaceSmall,
                        Text(
                          "User type",
                          style: kSmallRegularTextStyle.copyWith(
                              color: kBlackColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

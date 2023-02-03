import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  fetchUserinfo() async {
    http.Response res = await userProvider.fetchInfoe();

    setState(() {
      userList = welcomeFromJson(res.body);
    });

    print(res.body);
    // print(accesTok);
  }

  @override
  void initState() {
    isloading = true;
    fetchUserinfo();
    isloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        horizontalSpaceRegular,
        isloading == false
            ? Column(
                children: [
                  ...userList.map(
                    (e) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                          // SizedBox(
                          //   width: 20,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.first_name,
                                style: kSubtitleTextStyle.copyWith(
                                    color: kBlackColor),
                              ),
                              verticalSpaceSmall,
                              Text(
                                e.last_name,
                                style: kTinyRegularTextStyle.copyWith(
                                    color: kBlackColor),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...userList.map(
              (e) {
                return Column(
                  children: [
                    Text(
                      // widget.transaction.amount,
                      e.first_name,

                      style: kSubtitleTextStyle.copyWith(color: kBlackColor),
                    ),
                    verticalSpaceSmall,
                    Text(
                      e.last_name,
                      style:
                          kSmallRegularTextStyle.copyWith(color: kBlackColor),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ],
    );
  }
}

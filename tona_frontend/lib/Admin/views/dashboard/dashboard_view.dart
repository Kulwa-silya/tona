import 'dart:convert';
import 'dart:io';
import 'package:machafuapp/Admin/ui/shared/edge_insect.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/spacing.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';
import 'package:machafuapp/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ui/shared/colors.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/widgets/all_expenses_card.dart';
import '../../ui/widgets/expenses_details.dart';
import '../../ui/widgets/main_header.dart';
import '../../ui/widgets/transactions_card.dart';
import '../../ui/widgets/transactions_gridview.dart';
import '../../ui/widgets/transactions_row.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  MainView mainView = MainView();

  // dynamic jsondat;

  String? accesTok;

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });

    return stringValue;
  }

  // fetchUserData() async {
  //   final response = await http.get(
  //     Uri.parse("https://tona-production-8ea1.up.railway.app/auth/users/me/"),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "JWT $accesTok",
  //       "Accept": "application/json",
  //       'Content-Type': 'application/json'
  //     },
  //   );
  //   final jsondat = jsonDecode(response.body);
  //   print(jsondat);
  //   return response;
  // }
  @override
  void initState() {
    getAccessToken().then((value) {
      fetchUserData();
    });

    super.initState();
  }

  fetchUserData() async {
    // try {
    final response = await http.get(
      Uri.parse('https://tona-production.up.railway.app/auth/users/me/'),
      headers: {
        HttpHeaders.authorizationHeader: "JWT $accesTok",
        "Accept": "application/json",
        'Content-Type': 'application/json'
      },
    );

    // if (response.statusCode == 200) {
    final jsondat = jsonDecode(response.body);
    print("tok ni $accesTok");
    print(jsondat);
    return jsondat;
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
    // } catch (e) {
    //   print('Error during http request: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Size _size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: fetchUserData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          } else {
            String name = snapshot.data['last_name'];
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      verticalSpaceSmall,
                      MainHeader(
                        name: name,
                      ),
                      verticalSpaceRegular,
                      Container(
                        padding: kEdgeInsetsHorizontalNormal,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kBlackColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Balance',
                                  style: kBodyRegularTextStyle.copyWith(
                                    color: kWhiteColor,
                                  ),
                                ),
                                verticalSpaceSmall,
                                Text(
                                  '500,000 TZS',
                                  style: kHeading2TextStyle.copyWith(
                                    color: kWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: kEdgeInsetsHorizontalNormal,
                              height: height * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kWhiteColor),
                              child: Center(
                                child: Text(
                                  'See more',
                                  style: kBodyTextStyle.copyWith(
                                      color: kBlackColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        height: height * 0.20,
                      ),
                      verticalSpaceRegular,
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Responsive(
                                mobile: TransactionsGridView(
                                  crossAxisCount: _size.width < 650 ? 2 : 4,
                                  childAspectRatio:
                                      _size.width < 650 && _size.width > 350
                                          ? 1
                                          : 1,
                                ),
                                tablet: const TransactionsGridView(),
                                desktop: TransactionsGridView(
                                  childAspectRatio:
                                      _size.width < 1400 ? 1.1 : 1.4,
                                ),
                              ),
                              verticalSpaceRegular,
                              const TransactionRow(
                                title: 'User(Employees)',
                                cardText: 'More',
                              ),
                              verticalSpaceRegular,
                              // for (final transaction in userList) ...[
                              TransactionsCard(),
                              // ],
                              verticalSpaceRegular,
                              if (!Responsive.isDesktop(context))
                                const SizedBox(height: defaultPadding),
                              if (Responsive.isMobile(context)) ...[
                                const AllExpensesCard(),
                                verticalSpaceRegular,
                                // const QuickTransferCard()
                              ],
                              verticalSpaceRegular
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpaceSmall,
                if (Responsive.isDesktop(context))
                  Expanded(
                    child: Padding(
                      padding: kEdgeInsetsAllSmall,
                      child: const ExpensesDetails(),
                    ),
                  ),
              ],
            );
          }
        });
  }
}

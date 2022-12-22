import 'package:flutter/material.dart';
import 'package:machafuapp/Shared/gettingTokens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../../responsive.dart';
import '../../ui/shared/spacing.dart';
import '../../ui/widgets/side_menu.dart';
import '../dashboard/dashboard_view.dart';
import 'main_viewmodel.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String? accesTok;

  // GettingToken gettingToken = GettingToken();

  // var utoken;

  // @override
  // void initState() {
  //   gettingTok();
  //   super.initState();
  // }

  // void gettingTok() {
  //   var token = gettingToken.getAccessToken();

  //   setState(() {
  //     token = utoken;
  //   });

  //   print(utoken);
  // }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue;
    });

    print(accesTok);
    return stringValue;
  }

  @override
  void initState() {
    getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          drawer: const SideMenu(),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: SideMenu(),
                ),
              horizontalSpaceRegular,
              const Expanded(
                flex: 5,
                child: DashBoardView(),
              ),
              horizontalSpaceSmall,
            ],
          ),
        );
      },
      viewModelBuilder: () => MainViewModel(),
    );
  }
}

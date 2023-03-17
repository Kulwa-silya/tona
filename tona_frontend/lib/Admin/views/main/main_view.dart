import 'dart:async';
import 'package:flutter/material.dart';
import 'package:machafuapp/Auth/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
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
  late String accesTok;

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });

    return stringValue;
  }

  Future fetchProducts() async {
    final response = await http.get(
        Uri.parse(
            'https://tona-production-8ea1.up.railway.app/store/products/'),
        headers: {
          HttpHeaders.authorizationHeader: "JWT $accesTok",
        });

    return response;
  }

  bool _inactive = false;

  Future<void> deletePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('accesstoken');
    prefs.remove('refreshtoken');
  }

//check and logout
  void _resetTimer() {
    Timer _timer = Timer(Duration(minutes: 1200), _logOut);

    if (_inactive) {
      setState(() {
        _inactive = false;
        deletePreference();
      });
    }
    // _timer.cancel();
    _timer = Timer(Duration(minutes: 1200), _logOut);
  }

  void _logOut() {
    setState(() {
      _inactive = true;
    });
    // Perform the logout action here
  }

// cheks and log out ends

  @override
  void initState() {
    _resetTimer();
    getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, child) {
        return GestureDetector(
          // onTap: () => Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => SingIn()),
          //   (Route<dynamic> route) => false,
          // ),
          onTapDown: (_) => accesTok != null ? _resetTimer() : null,
          onPanDown: (_) => accesTok != null ? _resetTimer() : null,
          onScaleStart: (_) => accesTok != null ? _resetTimer() : null,
          child: _inactive == true
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SingIn()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Scaffold(body: Center(child: Text("your logged out"))))
              : Scaffold(
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
                ),
        );
      },
      viewModelBuilder: () => MainViewModel(),
    );
  }
}

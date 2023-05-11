import 'package:flutter/material.dart';

import '../../consts/Widgets/myBackBattn.dart';
import '../../consts/colorTheme.dart';
import '../../views/main/main_view.dart';

class Income extends StatefulWidget {
  String axxtok;
   Income({ required this.axxtok, Key? key}) : super(key: key);

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainView(Axtok: widget.axxtok)),
              (Route<dynamic> route) => false,
            );
          },
          child: const myBackButton(),
        ),
        elevation: 0,
        backgroundColor: ColorTheme.m_white,
      ),
      body: Container(
        child: Center(child: Text("Income Module")),
      ),
    );
  }
}

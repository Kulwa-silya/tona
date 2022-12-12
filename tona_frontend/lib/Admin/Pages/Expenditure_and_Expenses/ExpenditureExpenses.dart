import 'package:flutter/material.dart';

import '../../consts/Widgets/myBackBattn.dart';
import '../../consts/colorTheme.dart';
import '../../views/main/main_view.dart';

class ExpenditureExpenses extends StatefulWidget {
  const ExpenditureExpenses({Key? key}) : super(key: key);

  @override
  State<ExpenditureExpenses> createState() => _ExpenditureExpensesState();
}

class _ExpenditureExpensesState extends State<ExpenditureExpenses> {
  @override
  Widget build(BuildContext context) {

     return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainView()),
              (Route<dynamic> route) => false,
            );
          },
          child: const myBackButton(),
        ),
        elevation: 0,
        backgroundColor: ColorTheme.m_white,
      ),
      body: Container(
        child: Center(child: Text("Expenditure Module")),
      ),
    );
    
  }
}
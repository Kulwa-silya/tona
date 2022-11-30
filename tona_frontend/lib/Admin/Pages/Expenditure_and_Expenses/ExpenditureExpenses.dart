import 'package:flutter/material.dart';

class ExpenditureExpenses extends StatefulWidget {
  const ExpenditureExpenses({Key? key}) : super(key: key);

  @override
  State<ExpenditureExpenses> createState() => _ExpenditureExpensesState();
}

class _ExpenditureExpensesState extends State<ExpenditureExpenses> {
  @override
  Widget build(BuildContext context) {

     return Scaffold(
      body: Container(
        child: Center(child: Text("Expenditure Module")),
      ),
    );
    
  }
}
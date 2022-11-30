import 'package:flutter/material.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        child: Center(child: Text("Income Module")),
      ),
    );
  }
    
  }
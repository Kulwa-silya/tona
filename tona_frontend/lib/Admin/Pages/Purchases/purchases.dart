import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../consts/Widgets/myBackBattn.dart';
import '../../consts/colorTheme.dart';
import '../../views/main/main_view.dart';

class Purchases extends StatefulWidget {
  const Purchases({Key? key}) : super(key: key);

  @override
  State<Purchases> createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
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
        child: Center(child: Text("Purchases Module")),
      ),
    );
  }
}

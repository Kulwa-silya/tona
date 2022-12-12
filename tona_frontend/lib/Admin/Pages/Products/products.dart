import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machafuapp/Admin/views/main/main_view.dart';

import '../../consts/Widgets/myBackBattn.dart';
import '../../consts/colorTheme.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
        color: ColorTheme.m_white,
        child: Center(child: Text("products")),
      ),
    );
  }
}



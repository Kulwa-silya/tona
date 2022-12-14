import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitCubeGrid(
          // duration: Duration(milliseconds: 2000),
          // controller: AnimationController(
          //      duration: Duration(milliseconds: 2200),),

          color: ColorTheme.m_blue,
          size: 50.0,
        ),
      ),
    );
  }
}

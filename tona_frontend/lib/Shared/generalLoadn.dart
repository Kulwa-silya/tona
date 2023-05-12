import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Admin/consts/colorTheme.dart';

class Myloading extends StatefulWidget {
  const Myloading({Key? key}) : super(key: key);

  @override
  State<Myloading> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Myloading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWaveSpinner(
          color: ColorTheme.m_blue,
          waveColor: ColorTheme.m_blue_mpauko_zaidi,
          trackColor: ColorTheme.m_blue_mpauko_zaidi_zaidi,
          size: 50,
        ),
      ),
    );
  }
}

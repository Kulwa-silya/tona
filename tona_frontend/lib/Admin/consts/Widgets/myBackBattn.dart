// ignore: camel_case_types
import 'package:flutter/material.dart';

import '../colorTheme.dart';

class myBackButton extends StatelessWidget {
  const myBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: ColorTheme.m_blue,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 10,
                  color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                ),
              ))),
    );
  }
}
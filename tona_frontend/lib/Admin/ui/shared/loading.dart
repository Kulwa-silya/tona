import 'package:flutter/material.dart';

import '../../consts/colorTheme.dart';

class circularLoader extends StatelessWidget {
  const circularLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 1,
      color: ColorTheme.m_blue,
    );
  }
}
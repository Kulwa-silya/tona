import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

class Shimer extends StatelessWidget {
  const Shimer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      // duration: Duration(seconds: 3), // the duration of the animation
      // interval: Duration(seconds: 1), // the interval between shimmer animation loops
      // color: Colors.white, // the color of the shimmer effect
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [ColorTheme.m_grey, ColorTheme.m_white],
      ), // the gradient used for the shimmer effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 200.0,
          width: 200.0,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}

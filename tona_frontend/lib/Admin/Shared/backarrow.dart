import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';

class backArrow extends StatelessWidget {
  
   backArrow({
    Key? key,
    this.towhere
  }) : super(key: key);

  Widget? towhere;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushReplacementNamed(context, '/dash');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => towhere!),
          (Route<dynamic> route) => false,
        );
      },
      child: Padding(
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
      ),
    );
  }
}

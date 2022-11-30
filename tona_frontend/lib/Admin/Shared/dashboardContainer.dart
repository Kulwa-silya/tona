import 'package:flutter/material.dart';
import '../consts/colorTheme.dart';

class dashboardContainer extends StatelessWidget {
  String name;
  IconData iconName;

  dashboardContainer({Key? key, required this.name, required this.iconName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorTheme.m_blue,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconName,
            color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                    color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

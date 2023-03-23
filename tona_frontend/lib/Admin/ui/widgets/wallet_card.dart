import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import '../shared/colors.dart';
import '../shared/edge_insect.dart';
import '../shared/text_styles.dart';

class WalletCard extends StatelessWidget {
  var jsondat;

  WalletCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.desc,
    required this.onBTap,
    required this.amount,
  }) : super(key: key);

  final IconData icon;
  final Widget onBTap;
  final String text;
  final String desc;
  final String amount;

  fetchProductsCategory() async {
    final response = await http.get(
      Uri.parse('https://tona-production-8ea1.up.railway.app/store/products/'),
    );
    jsondat = jsonDecode(response.body);
    print(jsondat);
    return jsondat['results'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchProductsCategory(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Shimer();
          }
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => onBTap));
            },
            child: Container(
              padding: kEdgeInsetsAllNormal,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kTertiaryColor5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: kBlackColor),
                    child: Icon(
                      icon,
                      color: ColorTheme.m_white,
                    ),
                  ),
                  Text(
                    text,
                    style: kBodyTextStyle.copyWith(color: kBlackColor),
                  ),
                  Text(
                    desc,
                    style: kSmallRegularTextStyle.copyWith(color: kBlackColor),
                  ),
                  text == "Products"
                      ? Text(
                          snapshot.data.length.toString(),
                          style: kBodyTextStyle,
                        )
                      : Text(
                          amount,
                          style: kBodyTextStyle,
                        ),
                ],
              ),
            ),
          );
        });
  }
}

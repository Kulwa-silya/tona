import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import '../shared/colors.dart';
import '../shared/edge_insect.dart';
import '../shared/text_styles.dart';

class WalletCard extends StatefulWidget {
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

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  var jsondat;

  var endpoint1Data, endpoint2Data;

  int? productcount;

  var totalsales;

  fetchProductsCategory() async {
    final response = await http.get(
      Uri.parse('https://tona-production.up.railway.app/store/products/'),
    );
    jsondat = jsonDecode(response.body);
    print(jsondat);
    return jsondat['results'];
  }

  fetchAlldailySales() async {
    final response = await http.get(
      Uri.parse(
          'https://tona-production.up.railway.app/sales/dailysales/?search=2023-04-07'),
      headers: {
        HttpHeaders.authorizationHeader:
            "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgxMDY3MTM5LCJqdGkiOiIyOTQyZTExODIxMDg0Nzg2OTg2NjJkNmFiY2JiODVkZSIsInVzZXJfaWQiOjF9.fA8yLhC3L8GgNgkh3xq9IclOqXTPx1ZAcQK4wHfSGZs",
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    jsondat = jsonDecode(response.body);
    print(jsondat);
    return jsondat[0];
  }

  void fetchData() async {
    endpoint1Data = await fetchProductsCategory();
    endpoint2Data = await fetchAlldailySales();
    setState(() {
      productcount = endpoint1Data.length;
      totalsales = endpoint2Data['total_sales_revenue_on_day'];
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // future: widget.text == "Products"
        //     ? fetchProductsCategory()
        //     : (widget.text == "Sales" ? fetchAlldailySales() : null),

        // future: fetchAlldailySales(),
        builder: (context, AsyncSnapshot snapshot) {
      // if (!snapshot.hasData) {
      //   return Shimer();
      // }
      return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget.onBTap));
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
                    borderRadius: BorderRadius.circular(7), color: kBlackColor),
                child: Icon(
                  widget.icon,
                  color: ColorTheme.m_white,
                ),
              ),
              Text(
                widget.text,
                style: kBodyTextStyle.copyWith(color: kBlackColor),
              ),
              Text(
                widget.desc,
                style: kSmallRegularTextStyle.copyWith(color: kBlackColor),
              ),
              widget.text == "Products"
                  ? Text(
                      // snapshot.data.length.toString(),
                      productcount.toString(),
                      style: kBodyTextStyle,
                    )
                  : (widget.text == "Sales"
                      ? Text(
                          totalsales.toString().toString(),
                          style: kBodyTextStyle,
                        )
                      : Text(
                          widget.amount,
                          style: kBodyTextStyle,
                        ))
            ],
          ),
        ),
      );
    });
  }
}

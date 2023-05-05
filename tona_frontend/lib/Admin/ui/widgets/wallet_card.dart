import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    this.axxtok,
    required this.amount,
  }) : super(key: key);

  final IconData icon;
  final Widget onBTap;
  String? axxtok;
  final String text;
  final String desc;
  final String amount;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  var jsondat;

  var endpoint1Data, endpoint2Data;

  String? productcount = "loading...";

  String? totalsales = "loading...";
  String? accesTok;

  Future getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('accesstoken');
    setState(() {
      accesTok = stringValue!;
    });
    return stringValue;
  }

  fetchProductsCategory() async {
    final response = await http.get(
      Uri.parse('https://tona-production.up.railway.app/store/products/'),
    );
    jsondat = jsonDecode(response.body);
    print(jsondat);
    if (productcount=="loading...") {
          setState(() {
            productcount = "0";
          });
        }
    return jsondat['results'];
  }

  fetchAlldailySales() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://tona-production.up.railway.app/sales/dailysales/?search=${DateTime.now().toString().substring(0, 10)}'),
        headers: {
          HttpHeaders.authorizationHeader: "JWT $accesTok",
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      jsondat = jsonDecode(response.body);
      print(jsondat);
      print("muda ni: ${DateTime.now().toString().substring(0, 10)}");
      return jsondat[0];
    } catch (e) {
      
      return null;
    }
  }

  void fetchData() async {
    endpoint1Data = await fetchProductsCategory();
    endpoint2Data = await fetchAlldailySales();
    setState(() {
      productcount = endpoint1Data.length.toString();
      try {
        totalsales = endpoint2Data['total_sales_revenue_on_day'];
      } catch (e) {
        if (totalsales == "loading...") {
          setState(() {
            totalsales = "0.00";
          });
        }
      }
    });
  }

  @override
  void initState() {
    getAccessToken().then(
      (value) {
        fetchData();
      },
    );

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
      // return Shimer();
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
                      productcount!,
                      style: kBodyTextStyle,
                    )
                  : (widget.text == "Sales"
                      ? Text(
                          totalsales!.toString().toString(),
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

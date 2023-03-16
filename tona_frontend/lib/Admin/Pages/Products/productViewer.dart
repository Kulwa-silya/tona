import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machafuapp/Admin/Pages/Products/products.dart';
import 'package:machafuapp/Admin/Shared/backarrow.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';

class Viewer extends StatefulWidget {
  String? image, title, desc, uprice, tit;
  int? inventory, collId;

  Viewer(
      {required this.image,
      this.title,
      this.desc,
      required this.collId,
      required this.tit,
      this.inventory,
      this.uprice,
      Key? key})
      : super(key: key);

  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.m_white,
      body: Column(
        children: [
          Stack(
            children: [
              FadeInImage.assetNetwork(
                image: widget.image!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 300,
                placeholder: 'assets/images/image_1.png',
                imageErrorBuilder: (BuildContext? context, Object? error,
                        StackTrace? stackTrace) =>
                    Image.asset(
                  'assets/images/image_1.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  top: 30,
                  left: 1,
                  child: backArrow(
                    towhere: Products(
                      id: widget.collId,
                      title: widget.tit,
                    ),
                  ))
            ],
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)),
              child: Container(
                height: 500,
                color: ColorTheme.m_blue_mpauko_zaidi_zaidi,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title!,
                            style: TextStyle(
                                color: ColorTheme.m_blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            widget.uprice!,
                            style: TextStyle(
                                color: ColorTheme.m_blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 2),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            color: ColorTheme.m_blue_mpauko,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 2, 16, 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: ColorTheme.m_white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.desc!,
                              style: TextStyle(
                                  color: ColorTheme.m_blue,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 2, 16, 2),
                      child: Row(
                        children: [
                          Text(
                            "Inventory Count: ",
                            style: TextStyle(
                                color: ColorTheme.m_blue_mpauko,
                                fontWeight: FontWeight.w300,
                                fontSize: 13),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  color: ColorTheme.m_white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.inventory!.toString(),
                                      style: TextStyle(
                                          color: ColorTheme.m_blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

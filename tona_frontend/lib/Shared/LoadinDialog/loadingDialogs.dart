import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:machafuapp/Admin/consts/colorTheme.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                child: Dialog(
                  key: key,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SpinKitWaveSpinner(
                                color: ColorTheme.m_blue,
                                waveColor: ColorTheme.m_blue_mpauko_zaidi,
                                trackColor:
                                    ColorTheme.m_blue_mpauko_zaidi_zaidi,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }

        // SimpleDialog(
        //     key: key,
        //     backgroundColor: ColorTheme.m_blue_mpauko,
        //     children: <Widget>[
        //       Center(
        //         child: Column(children: [
        //           CircularProgressIndicator(),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           Text(
        //             "Please Wait...",
        //             style: kSmallRegularTextStyle,
        //           )
        //         ]),
        //       )
        //     ])
        );
    // });
  }
}

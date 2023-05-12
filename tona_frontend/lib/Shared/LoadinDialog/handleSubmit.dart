//  import 'package:flutter/material.dart';

// import 'loadingDialogs.dart';

// Future<void> _handleSubmit(BuildContext context) async {
//     try {
//       Dialogs.showLoadingDialog(context, _keyLoader);//invoking login
//       await serivce.login(user.uid);
//       Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
//       Navigator.pushReplacementNamed(context, "/home");
//     } catch (error) {
//       print(error);
//     }
//   }
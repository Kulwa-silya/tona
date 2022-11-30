
// import 'dart:convert';

// import 'package:http/http.dart' as http; 
 
//   Future<List> _login() async {
//     // final response = await http.post(
//     //     Uri.parse(
//     //         "https://mychoir2.000webhostapp.com/cityClean/getOccupant.php"),
//     //     body: {
//     //       "email": user.text,
//     //       "password": pass.text,
//     //     });

//     final response2 = await http.post(
//         Uri.parse("https://unremembered-disadv.000webhostapp.com/login.php"),
//         body: {
//           "username": user.text,
//           "password": pass.text,
//         });

//     // final response3 = await http.post(
//     //     Uri.parse(
//     //         "https://mychoir2.000webhostapp.com/cityClean/getRegisterers.php"),
//     //     body: {
//     //       "email": user.text,
//     //       "password": pass.text,
//     //     });

//     // var datauser = json.decode(response.body);
//     var datauser2 = json.decode(response2.body);
//     // var datauser3 = json.decode(response3.body);

//     if (datauser2.length == 1) {
//       // Navigator.pushReplacementNamed(context, '/Users');

//       if (datauser2[0]['role'] == 'manager') {
//         setState(() => loading = true);
//         // print(datauser);
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Managing(
//                       position: position,
//                       name: name,
//                     )));
//         // Navigator.pop(context);
//       } else if (datauser2[0]['role'] == 'driver') {
//         Navigator.pushReplacementNamed(context, '/Driver');
//       } else if (datauser2[0]['role'] == 'officer') {
//         Navigator.pushReplacementNamed(context, '/Officer');
//       } else if (datauser2[0]['role'] == 'user') {
//         // Navigator.pushReplacementNamed(context, '/Users');

//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Users(
//                       position: datauser2[0]['role'],
//                       fname: datauser2[0]['fname'],
//                       lname: datauser2[0]['lname'],
//                     )));
//       }
//       // Navigator.pushReplacementNamed(context, '/Users');
//       setState(() {
//         // name2 = datauser2[0]['fname'];
//         // name = datauser2[0]['lname'];
//         // position = datauser2[0]['role'];
//         // email2 = datauser2[0]['email'];
//         // idu = datauser2[0]['id'];
//         // booliy = datauser2[0]['bool'];
//         // booliy = boolAsString == datauser2[0]['bool'];
//       });
//     } else if (datauser2.length == 0) {
//       setState(() => loading = true);

//       setState(() {
//         displayDialog();
//       });

//       setState(() => loading = false);
//     } else {
//       // Navigator.pushReplacementNamed(context, '/Users');

//       // else if (datauser[0]['position'] == 'driver') {
//       //   // Navigator.pushReplacementNamed(context, '/Driver');
//       //   Navigator.of(context).push(new MaterialPageRoute(
//       //     builder: (BuildContext context) => Driver(),
//       //   ));
//       // }

//       setState(() {
//         // name2 = datauser[0]['fname'];
//         // name = datauser[0]['lname'];
//         // position = datauser[0]['position'];
//         // email = datauser[0]['email'];
//         // fname = datauser3[0]['fname'];
//         // booliy = boolAsString == datauser3[0]['bool'];
//         // jina = datauser3[0]['lname'];
//         // booliy1 = boolAsString == datauser3[1]['bool'];
//         //booliy2 = boolAsString == datauser3[2]['bool'];
//       });
//     }

//     return datauser2;
//   }
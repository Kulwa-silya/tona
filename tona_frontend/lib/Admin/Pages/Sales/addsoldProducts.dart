import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:machafuapp/Admin/ui/shared/loading.dart';
import 'package:machafuapp/Admin/ui/shared/text_styles.dart';

import '../../consts/colorTheme.dart';

class AddSoldProd extends StatefulWidget {
  const AddSoldProd({Key? key}) : super(key: key);

  @override
  State<AddSoldProd> createState() => _AddSoldProdState();
}

class _AddSoldProdState extends State<AddSoldProd> {
  bool saveAttempt = false;
  final formkey = GlobalKey<FormState>();
  TextEditingController cnameC = new TextEditingController();
  TextEditingController descC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();

  bool loading = false;

  DateTime? gdate;

  bool success = false;
  bool successErr = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 21, 8, 8),
                child: Center(
                  child: Text(
                    "Add Sold Product!",
                    style: TextStyle(
                        color: ColorTheme.m_blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return "Fill in Customer name";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Customer Name Format";
                            },
                            controller: cnameC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.adobe_sharp,
                              ),
                              labelText: "Customer Name",
                              hintText: "Ex: Norman Mushi",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorTheme.m_blue),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLength: 9,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return "Fill in Phone number";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Phone Number Format";
                            },
                            controller: phoneC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                              ),
                              labelText: "Phone Name",
                              hintText: "Ex: Electronics",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              prefix: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 0, 5, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: ColorTheme.m_blue_mpauko_zaidi,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "+255",
                                          style: kInfoRegularTextStyle,
                                        ),
                                      )),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorTheme.m_blue),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty) {
                                return "Fill in Description ";
                              }
                              RegExp regExp = new RegExp(
                                  "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}");
                              if (regExp.hasMatch(emailValue)) {
                                return null;
                              }
                              return "Invalid Description  Format";
                            },
                            controller: descC,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.description_rounded,
                              ),
                              labelText: "Description ",
                              hintText: "Ex: Type, form, condition",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorTheme.m_blue),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                        ),

                        TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  minTime: DateTime(2018, 3, 5),
                                  maxTime: DateTime(2049, 6, 7),
                                  showTitleActions: true, onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  gdate = date;
                                });
                              }, currentTime: DateTime.now());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: ColorTheme.m_blue_mpauko_zaidi,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            gdate == null ? "" : '$gdate',
                                            style: kBodyTextStyle),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Pick Date',
                                            style: kBodyRegularTextStyle),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        // Container(
                        //   child: SfDateRangePicker(
                        //     initialSelectedRange: PickerDateRange(
                        //       DateTime.now().subtract(Duration(days: 5)),
                        //       DateTime.now().add(Duration(days: 5)),
                        //     ),
                        //     selectionMode: DateRangePickerSelectionMode.range,
                        //     // dateFormat: 'dd/MM/yyyy',
                        //     onSelectionChanged:
                        //         (DateRangePickerSelectionChangedArgs args) {
                        //       // Handle the selection change event here
                        //     },
                        //   ),
                        // ),

                        success == true
                            ? circularLoader()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorTheme.m_red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Add',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorTheme.m_blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          saveAttempt = true;
                                        });

                                        if (formkey.currentState!.validate()) {
                                          formkey.currentState!.save();

                                          // _salesadd();
                                          setState(() {
                                            success = true;
                                            // successErr = true;
                                          });
                                          if (success == true)
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Sale added (${cnameC.text})",
                                                  style: TextStyle(
                                                      color: ColorTheme.m_blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor: ColorTheme
                                                  .m_blue_mpauko_zaidi,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 30,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              padding: EdgeInsets.all(3),
                                              action: SnackBarAction(
                                                label: 'Dismiss',
                                                disabledTextColor: Colors.white,
                                                textColor: ColorTheme.m_blue,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  //Do whatever you want
                                                },
                                              ),
                                            ));

                                          if (successErr == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Opps!, parhaps check your internet connection",
                                                  style: TextStyle(
                                                      color: ColorTheme.m_white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 103, 13, 7),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 30,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              padding: EdgeInsets.all(3),
                                              action: SnackBarAction(
                                                label: 'Dismiss',
                                                disabledTextColor: Colors.white,
                                                textColor: ColorTheme.m_white,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  //Do whatever you want
                                                },
                                              ),
                                            ));
                                          }
                                          // _useradd();
                                        } else {
                                          if (successErr == true) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Opps!, parhaps check your internet connection",
                                                  style: TextStyle(
                                                      color: ColorTheme.m_white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              backgroundColor: Color.fromARGB(
                                                  255, 103, 13, 7),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              elevation: 30,
                                              duration:
                                                  Duration(milliseconds: 2000),
                                              padding: EdgeInsets.all(3),
                                              action: SnackBarAction(
                                                label: 'Dismiss',
                                                disabledTextColor: Colors.white,
                                                textColor: ColorTheme.m_white,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  //Do whatever you want
                                                },
                                              ),
                                            ));
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                        // success ==false ?
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:machafuapp/Auth/signIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? accesTok = "null";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TONA Trader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SingIn(
            // accsstok: accesTok!,
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController controllerCode = new TextEditingController();
  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerPrice = new TextEditingController();
  TextEditingController controllerStock = new TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Uri url = Uri.parse('http://192.168.3.89:8000/patients/');

//get data
  Future<List> getData() async {
    final response = await http.get(url);
    return json.decode(response.body);
  }

//add data
  void addData() {
    http.post(url, body: {
      "first_name": "Machafuuuu",
      "middle_name": "O'Dare",
      "gender": "Female",
      "last_name": "Glassup",
      "birth_date": "2013-06-01",
      "phone": "817-865-5634",
      "city": "Xiaruyue",
      "street": "Loomis",
    });
  }

  //update data
  void editData() {
    http.post(url, body: {
      "id": 106,
      "first_name": controllerCode.text,
    });
  }

  void deleteData() {
    http.post(url, body: {
      "id": 106,
    });
  }

  @override
  void initState() {
    super.initState();

    controllerCode.text;
  }

  void _futanamba() {
    setState(() {
      _counter--;
    });
  }

  void _zidishanamba() {
    setState(() {
      _counter * 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snap) {
          // String fnam = snap.data![i]['first_name'];

          return Container(
            child: Column(children: [
              new TextFormField(
                controller: controllerCode,
                style: const TextStyle(fontSize: 15),
                decoration: new InputDecoration(
                    hintText: "First name", labelText: "enter first name"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        addData();
                      },
                      child: Text("add")),
                  ElevatedButton(
                      onPressed: () {
                        addData();
                      },
                      child: Text("update")),
                  ElevatedButton(
                      onPressed: () {
                        addData();
                      },
                      child: Text("delete")),
                ],
              )
            ]),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

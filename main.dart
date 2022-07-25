import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//ME 센서값 받아오기
Future<MEdata> fetchME() async {
  final response = await http
      .get(Uri.parse('http://badaro.kmou.ac.kr/ME.json')); //json파일을 받아올 주소

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    return MEdata.fromJson(json.decode(response.body));
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class MEdata {
  final int s_value;

  MEdata({required this.s_value});

  factory MEdata.fromJson(Map<String, dynamic> json) {
    return MEdata(
      s_value: json['s_value'],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _dataME = 0;
  int _dataDG = 0;
  int _dataECR = 0;
  //final audioPlayer = AudioPlayer();
  static AudioCache audioCache = new AudioCache(fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));


  @override
  void initState() {
    super.initState();
    getME();
    getDG();
    getECR();
  }

  Future<void> getME() async {
    final Xml2Json xml2Json = Xml2Json();
    var _url = 'http://192.168.0.160/';
    var response2 = await http.get(Uri.parse(_url), headers: {"Accept": "*/*"});

    if (response2.statusCode == 200) {
      xml2Json.parse(response2.body);
      var dataXml1 = xml2Json.toParker();
      var dataJsonXml1 = jsonDecode(dataXml1); // string to json
      setState(() {
        _dataME = int.parse(dataJsonXml1['s_value']);
      });
      print('$dataJsonXml1');
      print('${dataJsonXml1['s_value']}');
    } else {
      print('response status code = ${response2.statusCode}');
    }
  }

  Future<void> getDG() async {
    final Xml2Json xml2Json = Xml2Json();
    var _url = 'http://192.168.0.161/';
    var response2 = await http.get(Uri.parse(_url), headers: {"Accept": "*/*"});

    if (response2.statusCode == 200) {
      xml2Json.parse(response2.body);
      var dataXml2 = xml2Json.toParker();
      var dataJsonXml2 = jsonDecode(dataXml2); // string to json
      setState(() {
        _dataDG = int.parse(dataJsonXml2['s_value']);
      });
      print('$dataJsonXml2');
      print('${dataJsonXml2['s_value']}');
    } else {
      print('response status code = ${response2.statusCode}');
    }
  }

  Future<void> getECR() async {
    final Xml2Json xml2Json = Xml2Json();
    var _url = 'http://192.168.0.162/';
    var response2 = await http.get(Uri.parse(_url), headers: {"Accept": "*/*"});

    if (response2.statusCode == 200) {
      xml2Json.parse(response2.body);
      var dataXml3 = xml2Json.toParker();
      var dataJsonXml3 = jsonDecode(dataXml3); // string to json
      setState(() {
        _dataECR = int.parse(dataJsonXml3['s_value']);
      });
      print('$dataJsonXml3');
      print('${dataJsonXml3['s_value']}');
    } else {
      print('response status code = ${response2.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("SMOKE ALARM")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                smokeAlarmME(),
                Padding(padding: EdgeInsets.all(10)),
                smokeAlarmDG()
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                smokeAlarmECR(),
                Padding(padding: EdgeInsets.all(10)),
                Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x80cacaca),
                            offset: Offset(0, -1),
                            blurRadius: 16,
                            spreadRadius: 2)
                      ]),
                  child: Container(
                    padding: EdgeInsets.all(1.0),
                    child: TextButton(
                      onPressed: () {
                        setState(
                          () {
                            getME();
                            getDG();
                            getECR();
                          },
                        );
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'UPDATE',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  @override
  Widget smokeAlarmME() {
    if (_dataME <= 500) {
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x80cacaca),
                  offset: Offset(0, -1),
                  blurRadius: 16,
                  spreadRadius: 2)
            ]),
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: TextButton(
            onPressed: () {
              setState(
                () {
                  getME();
                },
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ME',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      audioCache.play('pump.wav');
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x80cacaca),
                  offset: Offset(0, -1),
                  blurRadius: 16,
                  spreadRadius: 2)
            ]),
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: TextButton(
            onPressed: () {
              setState(
                () {
                  getME();
                },
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ME',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '측정값 : ${_dataME}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
  @override
  Widget smokeAlarmDG() {
    if (_dataDG <= 500) {
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x80cacaca),
                  offset: Offset(0, -1),
                  blurRadius: 16,
                  spreadRadius: 2)
            ]),
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: TextButton(
            onPressed: () {
              setState(
                    () {
                  getDG();
                },
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'DG',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      audioCache.play('pump.wav');
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x80cacaca),
                  offset: Offset(0, -1),
                  blurRadius: 16,
                  spreadRadius: 2)
            ]),
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: TextButton(
            onPressed: () {
              setState(
                    () {
                  getDG();
                },
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'DG',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '측정값 : ${_dataDG}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
  @override
  Widget smokeAlarmECR() {
    if (_dataECR <= 500) {
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x80cacaca),
                  offset: Offset(0, -1),
                  blurRadius: 16,
                  spreadRadius: 2)
            ]),
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: TextButton(
            onPressed: () {
              setState(
                    () {
                  getECR();
                },
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ECR',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      audioCache.play('pump.wav');
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x80cacaca),
                  offset: Offset(0, -1),
                  blurRadius: 16,
                  spreadRadius: 2)
            ]),
        child: Container(
          padding: EdgeInsets.all(1.0),
          child: TextButton(
            onPressed: () {
              setState(
                    () {
                  getECR();
                },
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ECR',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '측정값 : ${_dataECR}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

}

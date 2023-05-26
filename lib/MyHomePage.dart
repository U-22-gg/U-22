import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Daily Finance',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.view_headline,
            ),
          ),
        ],
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(235, 110, 165, 1),
                      ),
                      onPressed: buttonPressed,
                      child: new Text(
                        "帳簿記入",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportPage()),
                        );
                      },
                      child: new Text(
                        "レポート",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MakeFile()),
                        );
                      },
                      child: new Text(
                        "書類作成",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvancedSetting()),
                        );
                      },
                      child: new Text(
                        "詳細設定",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ))
                ]),
            new Container(
              width: 200.0,
              height: 550.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.0,
                    blurRadius: 10.0,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: new Card(
                color: Color(0xfffffff9),
                child: Center(child: Text('帳簿記入用コンテナ')),
              ),
            )
          ]),
    );
  }

  void buttonPressed() {}
}

//ここまで帳簿記入用
//↓ここからレポート用

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);
  @override
  _ReportPageState createState() => new _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Daily Finance',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.view_headline,
            ),
          ),
        ],
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                      child: new Text(
                        "帳簿記入",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 169, 96, 1),
                      ),
                      onPressed: buttonPressed,
                      child: new Text(
                        "レポート",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MakeFile()),
                        );
                      },
                      child: new Text(
                        "書類作成",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvancedSetting()),
                        );
                      },
                      child: new Text(
                        "詳細設定",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ))
                ]),
            new Container(
              width: 200.0,
              height: 550.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.0,
                    blurRadius: 10.0,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: new Card(
                color: Color(0xfffffff9),
                child: Center(child: Text('レポート用コンテナ')),
              ),
            )
          ]),
    );
  }

  void buttonPressed() {}
}

//ここまでレポート用
//↓ここから書類作成用

class MakeFile extends StatefulWidget {
  MakeFile({Key? key}) : super(key: key);
  @override
  _MakeFileState createState() => new _MakeFileState();
}

class _MakeFileState extends State<MakeFile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Daily Finance',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.view_headline,
            ),
          ),
        ],
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                      child: new Text(
                        "帳簿記入",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportPage()),
                        );
                      },
                      child: new Text(
                        "レポート",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 217, 0, 7),
                      ),
                      onPressed: buttonPressed,
                      child: new Text(
                        "書類作成",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvancedSetting()),
                        );
                      },
                      child: new Text(
                        "詳細設定",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ))
                ]),
            new Container(
              width: 200.0,
              height: 550.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.0,
                    blurRadius: 10.0,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: new Card(
                color: Color(0xfffffff9),
                child: Center(child: Text('書類作成用コンテナ')),
              ),
            )
          ]),
    );
  }

  void buttonPressed() {}
}

//ここまで書類作成用
//↓ここから詳細設定用

class AdvancedSetting extends StatefulWidget {
  AdvancedSetting({Key? key}) : super(key: key);
  @override
  _AdvancedSettingState createState() => new _AdvancedSettingState();
}

class _AdvancedSettingState extends State<AdvancedSetting> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Daily Finance',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.view_headline,
            ),
          ),
        ],
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                      child: new Text(
                        "帳簿記入",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportPage()),
                        );
                      },
                      child: new Text(
                        "レポート",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MakeFile()),
                        );
                      },
                      child: new Text(
                        "書類作成",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      )),
                  new ElevatedButton(
                      key: null,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 175, 204, 1),
                      ),
                      onPressed: buttonPressed,
                      child: new Text(
                        "詳細設定",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto"),
                      ))
                ]),
            new Container(
              width: 200.0,
              height: 550.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.0,
                    blurRadius: 10.0,
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: new Card(
                color: Color(0xfffffff9),
                child: Center(child: Text('詳細設定用コンテナ')),
              ),
            )
          ]),
    );
  }

  void buttonPressed() {}
}

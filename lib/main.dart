import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({title: 'Flutter Demo'}) : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// データ用クラス
class Data {
  int _price;
  String _name;
  Data(this._name, this._price) : super();

  @override
  String toString() {
    return _name + ':' + _price.toString() + '円';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  //サンプルデータ
  static final _data = [
    Data('Apple', 200),
    Data('Orange', 150),
    Data('Peach', 300)
  ];
  Data _item = _data[0];

  void _setData() {
    setState(() {
      _item = (_data..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Data'),
      ),
      body: Text(
        _item.toString(),
        style: TextStyle(fontSize: 32.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setData,
        tooltip: 'set message.',
        child: Icon(Icons.star),
      ),
    );
  }
}

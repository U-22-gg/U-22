// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class LedgerPageScreen extends StatefulWidget {
  const LedgerPageScreen({Key? key}) : super(key: key);

  @override
  _LedgerPageScreenState createState() => _LedgerPageScreenState();
}

class _LedgerPageScreenState extends State<LedgerPageScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final textRecognizer = TextRecognizer();
  CameraController? _cameraController;
  String? _transactionType;
  String? _category;
  String? _expense;
  String? _memo;
  int? _amount;
  DateTime _date = DateTime.now();

  void _initCameraController(List<CameraDescription> cameras) {
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      final cameras = await availableCameras();
      _initCameraController(cameras);
    }
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;
    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final String totalAmount = parseTotalAmount(recognizedText.text);
      setState(() {
        _amount = int.tryParse(totalAmount);
      });
    } catch (e) {
      print(e);
    }
  }

  String parseTotalAmount(String text) {
    RegExp regExp = RegExp(r'合計\s*([\d,]+)', multiLine: true);
    var match = regExp.firstMatch(text);
    if (match != null) {
      return match.group(1)!.replaceAll(',', '');
    }
    return '0';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> saveTransaction() async {
    if (_transactionType == null ||
        _amount == null ||
        (_transactionType == 'Income' && _category == null) ||
        (_transactionType == 'Expense' && _expense == null)) {
      // Show some error and return
      Fluttertoast.showToast(
        msg: '未入力の項目があります',
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    final uid = _auth.currentUser?.uid ?? '';
    final transactionId = _firestore.collection('transaction').doc().id;

    //transactionTypeがExpenseなら-を付与する
    final int amount = _transactionType == 'Expense' ? -_amount! : _amount!;

    await _firestore.collection('transaction').doc(transactionId).set({
      'user_id': uid,
      'transaction_id': transactionId,
      'summary': _memo,
      'price': amount,
      'date': _date,
      'category': _transactionType == 'Income' ? _category : null,
      'expenses': _transactionType == 'Expense' ? _expense : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('帳簿記入'),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.view_headline,
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'スキャン'),
              Tab(text: '手動入力'),
              Tab(text: '銀行口座'),
              Tab(text: '使い方'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text('レシート読み取り', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 'Income',
                        groupValue: _transactionType,
                        onChanged: (String? value) {
                          setState(() {
                            _transactionType = value;
                          });
                        },
                      ),
                      Text('収入'),
                      Radio(
                        value: 'Expense',
                        groupValue: _transactionType,
                        onChanged: (String? value) {
                          setState(() {
                            _transactionType = value;
                          });
                        },
                      ),
                      Text('支出'),
                    ],
                  ),
                  if (_transactionType == 'Income')
                    DropdownButton<String>(
                      value: _category,
                      items: ['売上', '雑収入等'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                  if (_transactionType == 'Expense')
                    DropdownButton<String>(
                      value: _expense,
                      items: [
                        '仕入',
                        '給料賃金',
                        '外注工賃',
                        '減価償却費',
                        '貸倒金',
                        '地代家賃',
                        '利子割引料',
                        '租税公課',
                        '水道光熱費',
                        '旅費交通費',
                        '通信費',
                        '修繕費',
                        '消耗品費',
                        '雑費'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _expense = value;
                        });
                      },
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            int? parsedValue = int.tryParse(value);
                            if (parsedValue == null) {
                              print("Amount must be a number");
                              return;
                            }
                            _amount = parsedValue;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "金額",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          _requestCameraPermission();
                        },
                      ),
                    ],
                  ),
                  TextField(
                    onChanged: (value) {
                      _memo = value;
                    },
                    decoration: InputDecoration(
                      labelText: "摘要",
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _date = date;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: saveTransaction,
                    child: Text('登録'),
                  ),
                ],
              ),
            ),
            Center(
              child: Text('銀行口座', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('使い方', style: TextStyle(fontSize: 32.0)),
            ),
          ],
        ),
      ),
    );
  }
}

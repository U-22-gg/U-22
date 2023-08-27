// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class LedgerPageScreen extends StatefulWidget {
  const LedgerPageScreen({Key? key}) : super(key: key);

  @override
  _LedgerPageScreenState createState() => _LedgerPageScreenState();
}

class _LedgerPageScreenState extends State<LedgerPageScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? _transactionType;
  String? _category;
  String? _expense;
  String? _memo;
  int? _amount;
  DateTime _date = DateTime.now();
  Text? _text;
  Image? _image;
  String? _items;
  String? _prices;

  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  Future<void> scan(bool isGallery) async {
    final pickedFile = await ImagePicker().pickImage(
        source: isGallery == true ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }

    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }

    final InputImage imageFile = InputImage.fromFilePath(_croppedFile!.path);
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.japanese);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(imageFile);

    final String text = recognizedText.text;

    setState(() {
      _text = Text(text);
      _image = Image.file(File(_croppedFile!.path));
    });
    textRecognizer.close();

    int pricearea = text.indexOf('¥');
    _prices = text.substring(pricearea);
    _items = text.substring(1, pricearea);
    List ItemList = _items!.split('\n');
    List<String> PriceList = _prices!.split('\n');
    List intList = PriceList.map((element) =>
            int.tryParse(element.replaceAll(RegExp(r'[^0-9]'), '')))
        .where((element) => element != null)
        .toList();
    int _amount = intList
        .map((element) => int.parse(element.toString()))
        .reduce((value, element) => value + element);

    final uid = _auth.currentUser?.uid ?? '';
    final transactionId = _firestore.collection('transaction').doc().id;
    // final summary = _transactionType == 'Income' ? _category : _expense;

    //transactionTypeがExpenseなら-を付与する
    _amount = _transactionType == 'Expense' ? -_amount! : _amount!;
      final scanId = _firestore.collection('scan').doc().id;
      await _firestore.collection('scan').doc(scanId).set({
        'user_id': uid,
        'scan_id': scanId,
        'items': _items,
        'prices': _prices,
        'date': _date,
      });
      await _firestore.collection('transaction').doc(transactionId).set({
        'user_id': uid,
        'transaction_id': transactionId,
        'memo': '',
        'price': -_amount,
        'date': _date,
        'category': null,
        'expenses': 'レシートスキャン',
        'scan_id': scanId,
      });
      Fluttertoast.showToast(
        msg: '保存しました',
        toastLength: Toast.LENGTH_LONG,
      );
    
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
    // final summary = _transactionType == 'Income' ? _category : _expense;

    //transactionTypeがExpenseなら-を付与する
    final int amount = _transactionType == 'Expense' ? -_amount! : _amount!;

    if (_text != null && _image != null) {
      final scanId = _firestore.collection('scan').doc().id;
      await _firestore.collection('scan').doc(scanId).set({
        'user_id': uid,
        'scan_id': scanId,
        'items': _items,
        'prices': _prices,
        'date': _date,
      });
      await _firestore.collection('transaction').doc(transactionId).set({
        'user_id': uid,
        'transaction_id': transactionId,
        'memo': _memo,
        'price': amount,
        'date': _date,
        'category': _transactionType == 'Income' ? _category : null,
        'expenses': _transactionType == 'Expense' ? _expense : null,
        'scan_id': scanId,
      });
    } else {
      await _firestore.collection('transaction').doc(transactionId).set({
        'user_id': uid,
        'transaction_id': transactionId,
        'memo': _memo,
        'price': amount,
        'date': _date,
        'category': _transactionType == 'Income' ? _category : null,
        'expenses': _transactionType == 'Expense' ? _expense : null,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
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
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_image != null) SafeArea(child: _image!),
                  _text == null ? Text('No Image') : _text!,
                  FloatingActionButton(
                      onPressed: () async {
                        await scan(true);
                        saveTransaction();
                      },
                      child: const Icon(Icons.photo_album)),
                  FloatingActionButton(
                      onPressed: () async {
                        await scan(false);
                      },
                      child: const Icon(Icons.photo_camera))
                ],
              ),
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
                      Text('Income'),
                      Radio(
                        value: 'Expense',
                        groupValue: _transactionType,
                        onChanged: (String? value) {
                          setState(() {
                            _transactionType = value;
                          });
                        },
                      ),
                      Text('Expense'),
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
                  TextField(
                    onChanged: (value) {
                      int? parsedValue = int.tryParse(value);
                      if (parsedValue == null) {
                        print("Amount must be a number");
                        return;
                      } //数字でない文字が入力された場合
                      _amount = parsedValue;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "金額",
                    ),
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
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

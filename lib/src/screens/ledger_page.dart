// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  int? _amount;
  DateTime _date = DateTime.now();

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
    final summary = _transactionType == 'Income' ? _category : _expense;

    //transactionTypeがExpenseなら-を付与する
    final int amount = _transactionType == 'Expense' ? -_amount! : _amount!;

    await _firestore.collection('transaction').doc(transactionId).set({
      'user_id': uid,
      'transaction_id': transactionId,
      'summary': summary,
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
                        '仕入あ',
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
                      labelText: "Amount",
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

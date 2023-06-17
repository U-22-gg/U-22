// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPageScreen extends StatelessWidget {
  const ReportPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    final uid = _auth.currentUser?.uid ?? '';

    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('レポート'),
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.view_headline,
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true, // スクロールを有効化
            tabs: <Widget>[
              Tab(text: 'マイレポート'),
              Tab(text: '使い方'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('transaction')
                    .where('user_id', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final transactions = snapshot.data!.docs;
                  Map<String, int> incomeTotals = {};
                  Map<String, int> expenseTotals = {};
                  int overallTotal = 0;
                  for (var transaction in transactions) {
                    final category = transaction['category'];
                    final expenses = transaction['expenses'];
                    final Map<String, dynamic>? data =
                        transaction.data() as Map<String, dynamic>?;
                    final price = data != null && data.containsKey('price')
                        ? transaction.get('price') as int
                        : 0;

                    if (category != null) {
                      incomeTotals[category] =
                          (incomeTotals[category] ?? 0) + price;
                    }

                    if (expenses != null) {
                      expenseTotals[expenses] =
                          (expenseTotals[expenses] ?? 0) + price;
                    }

                    overallTotal += price;
                  }

                  List<Widget> incomeWidgets =
                      incomeTotals.entries.map((entry) {
                    return ListTile(
                      title: Text('${entry.key}: ${entry.value}'),
                    );
                  }).toList();

                  List<Widget> expenseWidgets =
                      expenseTotals.entries.map((entry) {
                    return ListTile(
                      title: Text('${entry.key}: ${entry.value}'),
                    );
                  }).toList();

                  return ListView(
                    children: [
                      ListTile(
                          title: Text('収入',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold))),
                      ...incomeWidgets,
                      ListTile(
                          title: Text('支出',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold))),
                      ...expenseWidgets,
                      ListTile(
                        title: Text('合計: $overallTotal',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              ),
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

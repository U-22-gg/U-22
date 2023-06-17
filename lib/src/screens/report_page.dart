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
                  Map<String, int> totals = {};
                  int overallTotal = 0;
                  for (var transaction in transactions) {
                    final category =
                        transaction['category'] ?? transaction['expenses'];
                    final Map<String, dynamic>? data =
                        transaction.data() as Map<String, dynamic>?;
                    final price = data != null && data.containsKey('price')
                        ? transaction.get('price') as int
                        : 0;
                    if (totals.containsKey(category)) {
                      totals[category] = (totals[category] ?? 0) + price;
                    } else {
                      totals[category] = price;
                    }
                    overallTotal += price;
                  }

                  return ListView(
                    children: totals.entries.map((entry) {
                      return ListTile(
                        title: Text('${entry.key}: ${entry.value}'),
                      );
                    }).toList()
                      ..add(
                        ListTile(
                          title: Text('合計: $overallTotal'),
                        ),
                      ),
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

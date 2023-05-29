import 'package:flutter/material.dart';

class LedgerPageScreen extends StatelessWidget {
  const LedgerPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 4, // タブの数
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.view_headline,
              ),
            ),
          ],
          title: const Text('帳簿記入'),
          bottom: const TabBar(
            isScrollable: true, // スクロールを有効化
            tabs: <Widget>[
              Tab(text: 'スキャン'),
              Tab(text: '手動入力'),
              Tab(text: '銀行口座'),
              Tab(text: '使い方'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text('レシート読み取り', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('手動入力', style: TextStyle(fontSize: 32.0)),
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

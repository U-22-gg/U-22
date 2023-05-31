import 'package:flutter/material.dart';

class ReportPageScreen extends StatelessWidget {
  const ReportPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text('マイレポート', style: TextStyle(fontSize: 32.0)),
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

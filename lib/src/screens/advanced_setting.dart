import 'package:flutter/material.dart';

class AdvancedSettingScreen extends StatelessWidget {
  const AdvancedSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 6, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('詳細設定'),
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
              Tab(text: '確定申告'),
              Tab(text: '口座'),
              Tab(text: '事業所'),
              Tab(text: '請求書'),
              Tab(text: 'マイデータ'),
              Tab(text: 'サポート'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text('確定申告', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('口座', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('事業所', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('請求書', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('マイデータ', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('サポート', style: TextStyle(fontSize: 32.0)),
            ),
          ],
        ),
      ),
    );
  }
}

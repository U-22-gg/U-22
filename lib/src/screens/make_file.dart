import 'package:flutter/material.dart';

class MakeFileScreen extends StatelessWidget {
  const MakeFileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('書類作成'),
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
              Tab(text: 'PDF出力'),
              Tab(text: '使い方'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Image.asset('images/document2.png',
                  width: MediaQuery.of(context).size.width * 1.25,
                  height: 400,
                  fit: BoxFit.cover),
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

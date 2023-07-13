import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvancedSettingScreen extends StatelessWidget {
  const AdvancedSettingScreen({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 3, // タブの数
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
              Tab(text: 'マイデータ'),
              Tab(text: 'サポート'),
              Tab(text: 'ログアウト'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text('マイデータ', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('サポート', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: ElevatedButton(
                child: Text('ログアウト', style: TextStyle(fontSize: 32.0)),
                onPressed: () async {
                  await _signOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

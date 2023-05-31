import 'package:flutter/material.dart';

class AdvancedSettingScreen extends StatelessWidget {
  const AdvancedSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '詳細設定',
          style: TextStyle(fontFamily: 'NotoSansJP'),
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.view_headline,
            ),
          ),
        ],
      ),
      body: const Center(
          child: Text('詳細設定画面',
              style: TextStyle(fontSize: 32.0, fontFamily: 'NotoSansJP'))),
    );
  }
}

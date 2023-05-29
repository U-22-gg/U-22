import 'package:flutter/material.dart';

class MakeFileScreen extends StatelessWidget {
  const MakeFileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body:
          const Center(child: Text('書類作成画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}

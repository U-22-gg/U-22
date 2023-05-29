
import 'package:flutter/material.dart';

class ReportPageScreen extends StatelessWidget {
  const ReportPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body:
          const Center(child: Text('レポート画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}

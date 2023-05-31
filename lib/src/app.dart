import 'package:flutter/material.dart';

import 'screens/ledger_page.dart';
import 'screens/report_page.dart';
import 'screens/make_file.dart';
import 'screens/advanced_setting.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.lightBlue, fontFamily: 'NotoSansJP'),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    LedgerPageScreen(),
    ReportPageScreen(),
    MakeFileScreen(),
    AdvancedSettingScreen()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.auto_stories), label: '帳簿記入'),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_page), label: 'レポート'),
            BottomNavigationBarItem(
                icon: Icon(Icons.upload_file), label: '書類作成'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '詳細設定'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}

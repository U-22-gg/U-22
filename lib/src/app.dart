// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';

import 'screens/ledger_page.dart';
import 'screens/report_page.dart';
import 'screens/advanced_setting.dart';

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.lightBlue, fontFamily: 'NotoSansJP'),
      home: user == null
          ? LoginScreen()
          : MyStatefulWidget(), //ログインが確認できていない場合のみLoginScreenへ遷移する
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static final List<StatefulWidget> _screens = [
    ReportPageScreen(),
    LedgerPageScreen(),
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
            icon: Icon(Icons.contact_page),
            label: 'レポート',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: '帳簿記入',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '詳細設定',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
class ReportPageScreen extends StatefulWidget {
  const ReportPageScreen({Key? key}) : super(key: key);

  @override
  _ReportPageScreenState createState() => _ReportPageScreenState();
}

class _ReportPageScreenState extends State<ReportPageScreen> {
  String? _month;
  DateTime? _months;
  DateTime? _monthe;

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _firestore = FirebaseFirestore.instance;
    final uid = _auth.currentUser?.uid ?? '';

    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 3, // タブの数
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
              Tab(text: 'グラフ'),
              Tab(text: '使い方'),
            ],
            labelStyle: TextStyle(fontSize: 15.0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  DropdownButton(
                    value: _month,
                    items: [
                      '合計',
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '10',
                      '11',
                      '12',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _month = value;
                      });
                      if (_month != '合計') {
                        var now = DateTime.now();
                        var year = now.year;
                        var selectedMonth = int.parse(_month!);
                        var firstDayOfMonth = DateTime(year, selectedMonth, 1);
                        var lastDayOfMonth =
                            DateTime(year, selectedMonth + 1, 0);
                        setState(() {
                          _months = firstDayOfMonth;
                          _monthe = lastDayOfMonth;
                        });
                      } else {
                        var now = DateTime.now();
                        var year = now.year;
                        _months = DateTime(year, 1, 1);
                        _monthe = DateTime(year, 12, 31);
                      }
                    },
                  ),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: _firestore
                          .collection('transaction')
                          .where(
                            'user_id',
                            isEqualTo: uid,
                          )
                          .where('date',
                              isGreaterThanOrEqualTo: _months,
                              isLessThanOrEqualTo: _monthe)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final transactions = snapshot.data!.docs;
                        Map<String, int> incomeTotals = {};
                        Map<String, int> expenseTotals = {};
                        double overallTotal = 0;
                        for (var transaction in transactions) {
                          final category = transaction['category'];
                          final expenses = transaction['expenses'];

                          final Map<String, dynamic>? data =
                              transaction.data() as Map<String, dynamic>?;
                          final price =
                              data != null && data.containsKey('price')
                                  ? transaction.get('price') as int
                                  : 0;

                          if (category != null) {
                            incomeTotals[category] =
                                (incomeTotals[category] ?? 0) + price;
                          }

                          if (expenses != null) {
                            expenseTotals[expenses] =
                                (expenseTotals[expenses] ?? 0) + price;
                          }

                          overallTotal += price;
                        }

                        List<Widget> incomeWidgets =
                            incomeTotals.entries.map((entry) {
                          return ListTile(
                            title: Text('${entry.key}: ${entry.value}'),
                          );
                        }).toList();

                        List<Widget> expenseWidgets =
                            expenseTotals.entries.map((entry) {
                          return ListTile(
                            title: Text('${entry.key}: ${entry.value}'),
                          );
                        }).toList();

                        return ListView(
                          children: [
                            ListTile(
                                title: Text('収入',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                            ...incomeWidgets,
                            ListTile(
                                title: Text('支出',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                            ...expenseWidgets,
                            ListTile(
                              title: Text('合計: $overallTotal',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: _firestore
                          .collection('transaction')
                          .where(
                            'user_id',
                            isEqualTo: uid,
                          )
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final transactions = snapshot.data!.docs;
                        Map<String, int> incomeTotals = {};
                        Map<String, int> expenseTotals = {};
                        Map<num, num> monthlyTotal = {};
                        Map<num, num> sumMap = {};
                        for (var transaction in transactions) {
                          final category = transaction['category'];
                          final expenses = transaction['expenses'];
                          num _price = transaction['price'];
                          final Map<String, dynamic>? data =
                              transaction.data() as Map<String, dynamic>?;
                          final price =
                              data != null && data.containsKey('price')
                                  ? transaction.get('price') as int
                                  : 0;

                          if (category != null) {
                            incomeTotals[category] =
                                (incomeTotals[category] ?? 0) + price;
                          }

                          if (expenses != null) {
                            expenseTotals[expenses] =
                                (expenseTotals[expenses] ?? 0) + price;
                          }

                          DateTime date =
                              (transaction['date'] as Timestamp).toDate();
                          int m = date.month;
                          monthlyTotal[m] = _price;
                         
                         

                          monthlyTotal.forEach((key, value) {
                            if (sumMap.containsKey(key)) {
                              sumMap[key] = (sumMap[key] ?? 0) + value;
                            } else {
                              sumMap[key] = value;
                            }
                          });
                        }


                        return BarChart(BarChartData(
                          
                          maxY: sumMap.values.reduce((value, element) => value > element ? value : element).toDouble()??0,
                          minY: -(sumMap.values.reduce((value, element) => value > element ? value : element).toDouble()??0),
                          barGroups: [
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                toY: sumMap[1]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(
                                toY: sumMap[2]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(
                                toY: sumMap[3]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(
                                toY: sumMap[4]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(
                                toY: sumMap[5]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(
                                toY: sumMap[6]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 7, barRods: [
                            BarChartRodData(
                                toY: sumMap[7]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 8, barRods: [
                            BarChartRodData(
                                toY: sumMap[8]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 9, barRods: [
                            BarChartRodData(
                                toY: sumMap[9]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 10, barRods: [
                            BarChartRodData(
                                toY: sumMap[10]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 11, barRods: [
                            BarChartRodData(
                                toY: sumMap[11]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                          BarChartGroupData(x: 12, barRods: [
                            BarChartRodData(
                                toY: sumMap[12]?.toDouble() ?? 0, width: 10, color: Colors.amber),
                          ]),
                        ]));
                      },
                    ),
                  ),
                ],
              ),
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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'package:logger/logger.dart';
import 'providers/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Loggerのインスタンスを作成
  var logger = Logger();

  Firebase.initializeApp().then((value) {
    runApp(
      ProviderScope(
        child: Consumer(builder: (context, ref, _) {
          final asyncValue = ref.watch(authStateProvider);
          return asyncValue.when(
            data: (user) => MyApp(user: user), // user data を MyApp に渡す
            loading: () => CircularProgressIndicator(),
            error: (_, __) => Text('Something went wrong'), // エラーハンドリング
          );
        }),
      ),
    );
  }).catchError((err) {
    logger.e('Error initializing Firebase: $err');
  });
}

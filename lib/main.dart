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
          // change watch to ref
          final asyncValue = ref.watch(
              authStateProvider); // change watch(authStateProvider) to ref.watch(authStateProvider)
          return asyncValue.when(
            data: (user) => MyApp(user: user), // Pass the user data to MyApp
            loading: () =>
                CircularProgressIndicator(), // Show loading indicator while waiting for data
            error: (_, __) => Text('Something went wrong'), // Handle error
          );
        }),
      ),
    );
  }).catchError((err) {
    logger.e('Error initializing Firebase: $err');
  });
}

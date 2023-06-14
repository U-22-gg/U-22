// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'providers/auth.dart';
import 'src/app.dart';

final firestoreProvider = Provider<FirebaseFirestore>(
    (ref) => FirebaseFirestore.instance); //firestoreのprovider

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

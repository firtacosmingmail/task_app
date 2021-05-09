import 'package:flutter/material.dart';
import 'package:task_app_for_daniel/consts/app_theme.dart';
import 'package:task_app_for_daniel/services/local_storage.dart';
import 'package:task_app_for_daniel/screens/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  LocalStorage storage = LocalStorage();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: LoadingScreen(storage: storage),
    );
  }
}

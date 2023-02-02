import 'package:example/features/books/view/book_view.dart';
import 'package:example/project/hive_constants.dart';
import 'package:example/project/project_constants.dart';
import 'package:example/project/project_globals.dart';
import 'package:example/project/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //initialize Hive before using
  await Hive.initFlutter(HiveConstants.hiveDbName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ProjectConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ProjectTheme().theme,
      scaffoldMessengerKey: snackBarKey,
      home: const BookView(),
    );
  }
}

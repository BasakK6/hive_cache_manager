import 'package:example/project/project_globals.dart';
import 'package:flutter/material.dart';

class Utility {
  void showSnackBar(String message) {
    final SnackBar snackBar =
        SnackBar(content: Text(message), duration: const Duration(seconds: 1));
    snackBarKey.currentState?.showSnackBar(snackBar);
  }
}

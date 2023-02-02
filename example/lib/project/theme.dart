import 'package:flutter/material.dart';

class ProjectTheme {
  ThemeData theme = ThemeData(
    primaryColor: Colors.blue,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          secondary: Colors.blue.shade100,
        ),
  );
}

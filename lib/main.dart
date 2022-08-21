import 'package:flutter/material.dart';

import 'main_ui.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBarTheme appBarTheme = AppBarTheme(
      backgroundColor: Colors.grey.shade900,
      foregroundColor: Colors.white
    );
    final ThemeData theme = ThemeData(
      appBarTheme: appBarTheme,
      brightness: Brightness.light,
      primaryColor: Colors.grey.shade900,
    );
    final ThemeData darkTheme = ThemeData(
      appBarTheme: appBarTheme,
      brightness: Brightness.dark,
      primaryColor: Colors.grey.shade900,
    );
    return new MaterialApp(
      title: 'KCSTM',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.indigo)
      ),
      darkTheme: darkTheme.copyWith(
          colorScheme: theme.colorScheme.copyWith(secondary: Colors.indigo)
      ),
      themeMode: ThemeMode.system,
      home: new EventListPage(title: 'KCSTM'),
    );
  }
}
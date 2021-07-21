import 'package:flutter/material.dart';

import 'main_ui.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'KCSTM',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey.shade900,
        accentColor: Colors.indigo,

      ),
      darkTheme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey.shade900,
        accentColor: Colors.indigo
      ),
      themeMode: ThemeMode.system,
      home: new EventListPage(title: 'KCSTM'),
    );
  }
}
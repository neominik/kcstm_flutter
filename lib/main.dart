import 'package:flutter/material.dart';

import 'main_ui.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'KCSTM',
      theme: new ThemeData(
        primaryColor: Colors.grey.shade800,
      ),
      home: new EventListPage(title: 'KCSTM'),
    );
  }
}
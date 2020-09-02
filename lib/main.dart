import 'package:flutter/material.dart';
import 'package:muscle_kim_flutter_refactoring/screen/timepicker_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String title = 'muscle Kim';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
    ),
      home: TimePickerScreen(title: title),
    );
  }
}

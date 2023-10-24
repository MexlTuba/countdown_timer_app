import 'package:flutter/material.dart';
import 'countdown.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Countdown Timer Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PomodoroTimer(),
      ),
    );
  }
}

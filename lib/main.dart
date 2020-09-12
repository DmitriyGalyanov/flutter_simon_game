import 'package:flutter/material.dart';
import 'package:flutter_simon_game/components/SimonGame.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Simon Game',
        theme: ThemeData(
            primaryColor: Colors.purpleAccent,
            accentColor: Colors.cyan
        ),
        home: SimonGame(0)
    );
  }
}
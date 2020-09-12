import 'package:flutter/material.dart';
import 'package:flutter_simon_game/components/SimonGame.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Simon Game',
        theme: ThemeData(
            primaryColor: Colors.purpleAccent
        ),
        home: SimonGame(0)
        // Scaffold(
        //   appBar: AppBar(
        //     title: Text('Simon Game')
        //   ),
        //   body: SimonGame(0)
        // )
    );
  }
}
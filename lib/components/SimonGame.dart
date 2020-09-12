import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:flutter_simon_game/components/GameSector.dart';

class SimonGame extends StatefulWidget {
  final int index;

  const SimonGame(this.index);

  @override
  _SimonGameState createState() => _SimonGameState();
}

class _SimonGameState extends State<SimonGame> {
  // GAME VARIABLES -- START
  int timeout = 1000; //milliseconds //level
  String language = 'en';
  int roundNumber = 10;
  bool isGameOn = false;
  bool isUserFail = false;
  bool isBlinking = false;

  void setLevel(int value) {
    setState(() {
      timeout = value;
    });
  }

  void setLanguage(String value) {
    setState(() {
      language = value;
    });
  }

  void increaseRoundNumber() {
    // start next round will come
    setState(() {
      roundNumber++;
    });
  }

  void setIsGameOn(bool value) {
    setState(() {
      isGameOn = value;
    });
  }

  void setIsUserFail(bool value) {
    setState(() {
      isUserFail = value;
    });
  }

  void setIsBlinking(bool value) {
    setState(() {
      isBlinking = value;
    });
  }

  // GAME VARIABLES -- END
  //
  // SECTORS -- START
  List<dynamic> sectorsInit = [
    //List<Map<String, dynamic>>
    {'id': 0, 'color': Colors.yellow, 'isHighlighted': false},
    {'id': 1, 'color': Colors.purpleAccent, 'isHighlighted': false},
    {'id': 2, 'color': Colors.deepOrange, 'isHighlighted': false},
    {'id': 3, 'color': Colors.cyan, 'isHighlighted': false},
  ];

  void blinkSector(int id) {
    print(600.0.floor());
    setState(() {
      sectorsInit[id]['isHighlighted'] = true;
    });
    Timer(
        Duration(milliseconds: 200),
        () => {
              setState(() {
                sectorsInit[id]['isHighlighted'] = false;
              })
            });
  }

  void blinkSectors() async { //void
    for (final sectorId in gameSelectedSectorsArray()) {
      await Future.delayed(Duration(milliseconds: timeout));
      blinkSector(sectorId);
    }
  }

  void handleSectorTap(int id) {
    blinkSector(id);
    addUserSelectedSector(id);
    print(userSelectedSectorsList);
  }

  Wrap _buildSectors() {
    List<Widget> sectors = [];
    sectorsInit.forEach((sector) {
      sectors.add(GameSector(
        sector['id'],
        sector['color'],
        handleSectorTap,
        timeout / 2, //2
        sector['isHighlighted'],
      ));
    });
    return Wrap(
      direction: Axis.vertical,
      children: [
        Row(children: sectors.sublist(0, 2)),
        Row(children: sectors.sublist(2, 4))
      ],
    );
  }

  // SECTORS -- END
  //
  // GET GAME SELECTED SECTORS LIST -- START
  List<int> gameSelectedSectorsArray() {
    List<int> data = [];
    for (int i = 0; i < roundNumber; i++) {
      data.add(Random().nextInt(4));
    }
    return data;
  }

  // GET GAME SELECTED SECTORS LIST -- END
  //
  // USER SELECTED SECTORS LIST -- START
  List<int> userSelectedSectorsList = [];

  void addUserSelectedSector(int id) {
    userSelectedSectorsList.add(id);
  }

  // USER SELECTED SECTORS LIST -- END

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simon Game')),
      body: Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Center(
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Container(
                margin: EdgeInsets.only(right: 8.0, top: 7.0),
                child: Column(
                  children: [
                    Text(
                      'Round number: $roundNumber',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    OutlineButton(
                      child: Text('Start blinking'),
                      onPressed: blinkSectors,
                    )
                  ],
                ),
              ),
              _buildSectors(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            // IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            blinkSectors();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

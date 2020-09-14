import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

// import 'package:audioplayers/audio_cache.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter_simon_game/components/GameSector.dart';
import 'package:flutter_simon_game/components/Button.dart';

class SimonGame extends StatefulWidget {
  final int index;

  const SimonGame(this.index);

  @override
  _SimonGameState createState() => _SimonGameState();
}

class _SimonGameState extends State<SimonGame> {
  // final player = AudioCache();
  // preloadAudio() {
  //   player.loadAll(['0.ogg', '1.ogg', '2.ogg', '3.ogg']);
  // }
  // void playAudio(int sectorId) { // via audioplayers
  //   AudioCache player = AudioCache();
  //   player.play('$sectorId.ogg');
  //   // player.play('sample.mp3');
  // }
  // final _assetsAudioPlayer = AssetsAudioPlayer();
  // void playAudio(int sectorId) {
    // print(sectorId);
    // _assetsAudioPlayer.open(AssetsAudio(
    //   asset: "$sectorId.ogg",
    //   folder: "assets/audio/gameAudio/"
    // ));
    // _assetsAudioPlayer.open(
    //   AssetsAudio(
    //     asset: assets[_currentAssetPosition],
    //     folder: "assets/audios/",
    //   ),
    // );
  // }

  // GAME VARIABLES -- START
  int timeout = 1000;
  String language = 'en'; //TODO: ADD LANGUAGE CHANGE
  Map languageLocales = {
    'ru': {
      'roundLabel': 'Раунд',
      'startNewGameButtonLabel': 'Новая игра',
      'repeatHighlightButtonLabel': 'Повторить последовательность',
      'tryLostRoundButtonLabel': 'Повторить последний раунд',
      'setEasyButtonLabel': 'легко',
      'setMediumButtonLabel': 'средне',
      'setHardButtonLabel': 'сложно'
    },
    'en': {
      'roundLabel': 'Round',
      'startNewGameButtonLabel': 'New game',
      'repeatHighlightButtonLabel': 'Repeat highlight',
      'tryLostRoundButtonLabel': 'Try lost round again',
      'setEasyButtonLabel': 'easy',
      'setMediumButtonLabel': 'medium',
      'setHardButtonLabel': 'hard'
    }
  };
  int roundNumber = 0;
  bool isGameOn = false;
  bool isUserFail = false;
  bool isBlinking = false;
  int gameSelectedAtRoundNumber = 0;
  List<int> gameSelectedSectorsList;
  List<int> userSelectedSectorsList = [];

  void setTimeout(int value) {
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

  void setGameSelectedSectorsList() {
    if (gameSelectedAtRoundNumber == roundNumber) return;
    List<int> data = [];
    for (int i = 0; i < roundNumber; i++) {
      data.add(Random().nextInt(4));
    }
    setState(() {
      gameSelectedSectorsList = data;
      gameSelectedAtRoundNumber = roundNumber;
    });
  }

  void addUserSelectedSector(int id) {
    userSelectedSectorsList.add(id);
  }

  void clearUserSelectedSectors() {
    userSelectedSectorsList.clear();
  }

  // GAME VARIABLES -- END
  //
  void startGame() {
    clearUserSelectedSectors();
    setIsGameOn(true);
    setIsUserFail(false);
    setState(() {
      roundNumber = 1;
    });
    setGameSelectedSectorsList();
    blinkSectors();
  }

  void startNextRound() {
    clearUserSelectedSectors();
    increaseRoundNumber();
    setGameSelectedSectorsList();
    blinkSectors();
  }

  void repeatHighlight() {
    if (isBlinking) return;
    clearUserSelectedSectors();
    blinkSectors();
  }

  void tryLostRound() {
    setIsUserFail(false);
    setIsGameOn(true);
    repeatHighlight();
  }

  checkIfUserFail(sectorId) {
    if (gameSelectedSectorsList[userSelectedSectorsList.length - 1] !=
        sectorId) {
      setIsUserFail(true);
      setIsGameOn(false);
    }
  }

  // SECTORS -- START
  List<dynamic> sectorsInit = [
    //List<Map<String, dynamic>>
    {'id': 0, 'color': Colors.yellow, 'isHighlighted': false},
    {'id': 1, 'color': Colors.purpleAccent, 'isHighlighted': false},
    {'id': 2, 'color': Colors.deepOrange, 'isHighlighted': false},
    {'id': 3, 'color': Colors.cyan, 'isHighlighted': false},
  ];

  void blinkSector(int sectorId) {
    //TODO: ADD AUDIO
    // playAudio(sectorId); //TODO: FIX THAT
    setState(() {
      sectorsInit[sectorId]['isHighlighted'] = true;
    });
    Timer(
        Duration(milliseconds: 200),
        () => {
              setState(() {
                sectorsInit[sectorId]['isHighlighted'] = false;
              })
            });
  }

  void blinkSectors() async {
    setIsBlinking(true);
    for (final sectorId in gameSelectedSectorsList) {
      await Future.delayed(Duration(milliseconds: timeout));
      blinkSector(sectorId);
    }
    await Future.delayed(Duration(milliseconds: (timeout / 2).floor()));
    setIsBlinking(false);
  }

  void handleSectorTap(int sectorId) {
    if (isBlinking) return;
    blinkSector(sectorId);
    if (!isGameOn) return;
    addUserSelectedSector(sectorId);
    checkIfUserFail(sectorId);
    if (!isUserFail &&
        gameSelectedSectorsList.length == userSelectedSectorsList.length) {
      startNextRound();
    }
  }

   Wrap _buildSectors() {
    //TODO: TRY STACK WITH CLIPPING
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
  // LAYOUTS -- START
  Widget portraitLayout() {
    return Scaffold(
      appBar: AppBar(title: Text('Simon Game')),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 6.0),
          child: Column(
            children: [
              Wrap(
                direction: Axis.horizontal, //vertical
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8.0, top: 7.0),
                    child: Container(
                      alignment: language == 'ru' ? Alignment.center : null,
                      child: Column(
                        children: [
                          Text(
                            '${languageLocales[language]['roundLabel']}:$roundNumber',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          if (!isGameOn)
                            Button(
                              label: languageLocales[language]
                              ['startNewGameButtonLabel'],
                              handleTap: startGame,
                            ),
                          if (isGameOn)
                            Button(
                              //TODO: stop wrap with ru
                                label: languageLocales[language]
                                ['repeatHighlightButtonLabel'],
                                handleTap: repeatHighlight,
                                isDisabled: isBlinking ? true : false),
                          if (isUserFail)
                            Button(
                              label: languageLocales[language]
                              ['tryLostRoundButtonLabel'],
                              handleTap: tryLostRound,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (language == 'ru') Center(child: _buildSectors()),
                  if (language == 'en') _buildSectors(),
                ],
              ),
              Column(children: [
                RadioListTile(
                  title: Text(
                    languageLocales[language]['setEasyButtonLabel'],
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  value: 1500,
                  groupValue: timeout,
                  onChanged: isBlinking ? null : (value) => setTimeout(value),
                ),
                RadioListTile(
                  title: Text(
                    languageLocales[language]['setMediumButtonLabel'],
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  value: 1000,
                  groupValue: timeout,
                  onChanged: isBlinking ? null : (value) => setTimeout(value),
                ),
                RadioListTile(
                  title: Text(
                    languageLocales[language]['setHardButtonLabel'],
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  value: 500,
                  groupValue: timeout,
                  onChanged: isBlinking ? null : (value) => setTimeout(value),
                ),
              ])
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            Flexible(
              child: RadioListTile(
                title: Text(
                  'Русский',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                value: 'ru',
                groupValue: language,
                onChanged: (value) => setLanguage(value),
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: Text(
                  'English',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                value: 'en',
                groupValue: language,
                onChanged: (value) => setLanguage(value),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget landscapeLayout() {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(36.0),
          child: AppBar(title: Text('Simon Game'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: Wrap(
                      direction: Axis.horizontal, //vertical
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.0, top: 7.0),
                          child: Column(
                            children: [
                              Text(
                                '${languageLocales[language]['roundLabel']}:$roundNumber',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              if (!isGameOn)
                                Button(
                                  label: languageLocales[language]
                                  ['startNewGameButtonLabel'],
                                  handleTap: startGame,
                                ),
                              if (isGameOn)
                                Button(
                                  //TODO: stop wrap with ru
                                    label: languageLocales[language]
                                    ['repeatHighlightButtonLabel'],
                                    handleTap: repeatHighlight,
                                    isDisabled: isBlinking ? true : false),
                              if (isUserFail)
                                Button(
                                  label: languageLocales[language]
                                  ['tryLostRoundButtonLabel'],
                                  handleTap: tryLostRound,
                                ),
                            ],
                          ),
                        ),
                        _buildSectors(),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(children: [
                      RadioListTile(
                        title: Text(
                          languageLocales[language]['setEasyButtonLabel'],
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        value: 1500,
                        groupValue: timeout,
                        onChanged: isBlinking ? null : (value) => setTimeout(value),
                      ),
                      RadioListTile(
                        title: Text(
                          languageLocales[language]['setMediumButtonLabel'],
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        value: 1000,
                        groupValue: timeout,
                        onChanged: isBlinking ? null : (value) => setTimeout(value),
                      ),
                      RadioListTile(
                        title: Text(
                          languageLocales[language]['setHardButtonLabel'],
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        value: 500,
                        groupValue: timeout,
                        onChanged: isBlinking ? null : (value) => setTimeout(value),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 48.0,
        child: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              Flexible(
                child: RadioListTile(
                  title: Text(
                    'Русский',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  value: 'ru',
                  groupValue: language,
                  onChanged: (value) => setLanguage(value),
                ),
              ),
              Flexible(
                child: RadioListTile(
                  title: Text(
                    'English',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  value: 'en',
                  groupValue: language,
                  onChanged: (value) => setLanguage(value),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: edit view
    switch (MediaQuery.of(context).orientation) {
      case Orientation.portrait: return portraitLayout();
      case Orientation.landscape: return landscapeLayout();
    }
  }
}

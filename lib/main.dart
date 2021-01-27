import 'package:flutter/material.dart';
import 'package:flutterflappybird/src/game_engine.dart';
import 'package:flutterflappybird/widget/blocker.dart';

import 'widget/bird.dart';

void main() {
  runApp(const MaterialApp(home: Playground()));
}

class Playground extends StatefulWidget {
  const Playground({Key? key}) : super(key: key);

  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> with TickerProviderStateMixin {
  late GameEngine gameEngine;
  Bird get bird => gameEngine.bird;
  Blocker get blocker1 => gameEngine.blockers[0];
  Blocker get blocker2 => gameEngine.blockers[1];

  @override
  void initState() {
    WidgetsBinding?.instance?.addPostFrameCallback((Duration timeStamp) {
      gameEngine.init();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    gameEngine = GameEngine(
        stageHeight: MediaQuery.of(context).size.height / 3 * 2 - 20);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: onUserTap,
            child: buildStage(context),
          ),
          Align(
            alignment: Alignment(0, -0.6),
            child: StreamBuilder<bool>(
                stream: gameEngine.gameStatusPublisher.stream,
                initialData: false,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text('TAP TO START');
                  return snapshot.data ?? false
                      ? SizedBox()
                      : Text(
                          'TAP  TO  START',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        );
                }),
          ),
        ],
      ),
    );
  }

  Column buildStage(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blue,
            child: Stack(
              children: [
                bird.build(context),
                gameEngine.blockers[0].buildBlocker(context),
                gameEngine.blockers[1].buildBlocker(context),
              ],
            ),
          ),
        ),
        Container(
          height: 20,
          color: Colors.green,
        ),
        Expanded(
          child: buildScore(),
        ),
      ],
    );
  }

  Container buildScore() {
    final textStyle = TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400);
    return Container(
      color: Colors.brown,
      child: Row(
        children: [
          Expanded(
              child: Center(
            child: Text(
              'Score: ',
              style: textStyle,
            ),
          )),
          Expanded(
              child: Center(
            child: Text(
              'Highest Score: ',
              style: textStyle,
            ),
          )),
        ],
      ),
    );
  }

  void onUserTap() {
    if (gameEngine.gameHasStarted) {
      bird.drive();
    } else {
      gameEngine.startGame();
    }
  }
}

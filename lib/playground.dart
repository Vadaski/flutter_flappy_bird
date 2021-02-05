import 'package:flutter/material.dart';
import 'package:flutterflappybird/src/game_engine.dart';
import 'package:flutterflappybird/src/score_counter.dart';

import 'component_impl/bird_component.dart';
import 'component_impl/blocker_component.dart';

class Playground extends StatefulWidget {
  const Playground({Key? key}) : super(key: key);

  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> with TickerProviderStateMixin {
  late GameEngine gameEngine = GameEngine();
  BirdComponent get bird => gameEngine.bird;
  BlockerComponent get blocker1 => gameEngine.blockers[0];
  BlockerComponent get blocker2 => gameEngine.blockers[1];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      gameEngine.init();
    });
    super.initState();
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
                            fontWeight: FontWeight.w300
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
            color: Colors.blueAccent,
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
            child: StreamBuilder(
              initialData: 0,
              stream: counter.scoreEventPublisher.stream,
              builder: (context, score){
                return Text(
                  ' Score: ${score.data}',
                  style: textStyle,
                );
              },
            )
          )),
          Expanded(
              child: Center(
            child: StreamBuilder(
              initialData: 0,
              stream: counter.bestScoreEventPublisher.stream,
              builder: (context, score){
                return Text(
                  'Best Score: ${score.data}',
                  style: textStyle,
                );
              },
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
      gameEngine.startGame(context);
    }
  }
}

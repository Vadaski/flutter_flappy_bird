import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflappybird/component_impl/bird_animation.dart';
import 'package:flutterflappybird/src/magistrates.dart';
import 'package:flutterflappybird/component_impl/bird_component.dart';
import 'package:flutterflappybird/component_impl/blocker_component.dart';
import 'package:flutterflappybird/src/score_counter.dart';

class GameEngine {
  late Magistrates _magistrates;
  BirdComponent bird = BirdComponent(
      builder: (context, snapshot) {
        return SizedBox(
          height: 120,
          width: 120,
          child: BirdAnimation(),
        );
      },
      birdSize: Size.square(50));
  List<BlockerComponent> blockers = [
    BlockerComponent(
        upper: math.Random.secure().nextInt(10) + 2,
        lower: math.Random.secure().nextInt(10) + 2,
        blockerPosition: 3),
    BlockerComponent(
        upper: math.Random.secure().nextInt(10) + 2,
        lower: math.Random.secure().nextInt(10) + 2,
        blockerPosition: 4.5),
  ];

  bool gameHasStarted = false;

  StreamController<bool> gameStatusPublisher =
      StreamController<bool>.broadcast();

  late Timer timer;

  void init() {
    final List<RenderBox> blockerBoxList =
        blockers.map((blocker) => blocker.lowerBox).cast<RenderBox>().toList();

    blockerBoxList.addAll(
        blockers.map((blocker) => blocker.upperBox).cast<RenderBox>().toList());

    _magistrates = Magistrates(
      [bird.box as RenderBox],
      blockerBoxList,
    );
  }

  void startGame(BuildContext context) {
    gameHasStarted = true;
    gameStatusPublisher.add(gameHasStarted);
    createGameLooper(context);
  }

  void createGameLooper(BuildContext context) {
    timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      bird.update(timer);
      for (int i = 0; i < 10; i++) {
        blockers.forEach((blocker) => blocker.update(timer));
        if (_magistrates.hitTestEachObject()) {
          timer.cancel();
          bird.resetState();
          blockers.forEach((blocker) => blocker.resetState());
        }
      }

      if (!timer.isActive) {
        counter.resetState();
        blockers.forEach((blocker) => blocker.resetState());
        gameHasStarted = false;
        gameStatusPublisher.add(gameHasStarted);
        showCupertinoDialog<void>(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: const CupertinoAlertDialog(
                  title: Text('Game Over'),
                ),
              );
            });
      }
    });
  }
}

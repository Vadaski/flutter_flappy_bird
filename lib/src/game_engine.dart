import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflappybird/src/magistrates.dart';
import 'package:flutterflappybird/widget/bird.dart';
import 'package:flutterflappybird/widget/blocker.dart';

class GameEngine {
  GameEngine({
    required this.stageHeight,
  });

  late Magistrates _magistrates;
  Bird bird = Bird();
  List<Blocker> blockers = [
    Blocker(
        upper: math.Random.secure().nextInt(10) + 2,
        lower: math.Random.secure().nextInt(10) + 2,
        blockerPosition: 3),
    Blocker(
        upper: math.Random.secure().nextInt(10) + 2,
        lower: math.Random.secure().nextInt(10) + 2,
        blockerPosition: 4.5),
  ];
  final double stageHeight;

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

  void startGame() {
    gameHasStarted = true;
    gameStatusPublisher.add(gameHasStarted);
    timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      bird.startGame(timer);
      blockers.forEach((blocker) => blocker.roll());
      if (_magistrates.hitTestEachObject()) {
        timer.cancel();
        bird.resetState();
        blockers.forEach((blocker) => blocker.resetState());
      }
      if (!timer.isActive) {
        blockers.forEach((blocker) => blocker.resetState());
        gameHasStarted = false;
        gameStatusPublisher.add(gameHasStarted);
      }

    });

    RenderBox renderBox;
  }
}

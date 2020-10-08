///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 16:32
///
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final TweenSequence<double> _tweenSequence = TweenSequence<double>(
  <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      weight: 1.0,
    ),
    TweenSequenceItem<double>(
      tween: ConstantTween<double>(1.0),
      weight: 0.0125,
    ), // 滞空一小会儿~
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1.0, end: 0.0),
      weight: 1.0,
    ),
  ],
);

class NewBird {
  NewBird({
    @required this.mediaQuery,
    @required this.vsync,
    this.birdSize = const Size.square(50.0),
  }) : assert(!mediaQuery.size.isEmpty) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 750),
    );
    _animation = _tweenSequence.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.slowMiddle,
      ),
    );
    _animation.addListener(() {
      _streamController.add(_currentHeight + _animation.value * jumpingValue);
    });
  }

  final MediaQueryData mediaQuery;

  double get maxHeight => mediaQuery.size.height;

  final Size birdSize;

  double get jumpingValue => maxHeight / 6;

  double _currentHeight = 0.0;

  Offset get birdCenterPoint => Offset(birdSize.width / 2, birdSize.height / 2);

  final StreamController<double> _streamController =
      StreamController<double>.broadcast();

  Stream<double> get stream => _streamController.stream;

  set height(double value) {
    _streamController.add(value);
  }

  final Ticker ticker = Ticker((Duration elapsed) {});

  final TickerProvider vsync;

  AnimationController _animationController;

  Animation<double> _animation;

  AnimationController _fallAnimationController;

  Future<void> drive() async {
    _currentHeight += _animation.value * jumpingValue;
    _fallAnimationController?.stop();
    _animationController
      ..stop()
      ..reset();
    await _animationController.forward();
    _animationController.reset();
    if (_currentHeight > 0.0) {
      fallToGround();
    }
  }

  void fallToGround() {
    _fallAnimationController = AnimationController.unbounded(
      vsync: vsync,
      value: _currentHeight,
    )..addListener(() {
      _currentHeight = _fallAnimationController.value;
      _streamController.add(_currentHeight);
    });
    _fallAnimationController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500 * _currentHeight ~/ maxHeight),
      curve: Curves.linear,
    );
  }
}

///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 16:32
///
import 'dart:async';
import 'dart:ui' as ui;

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

class BirdPhysicsEngine {
  late final MediaQueryData _mediaQuery = MediaQueryData.fromWindow(ui.window);

  double get _maxHeight => _mediaQuery.size.height;

  final Size birdSize = const Size.square(50.0);

  double get _jumpingValue => _maxHeight / 6;

  double _currentHeight = 0.0;

  double get currentHeight => _currentHeight;

  final StreamController<double> _streamController =
      StreamController<double>.broadcast();

  Stream<double> get stream => _streamController.stream;

  late final TickerProvider _vsync;

  late final AnimationController _animationController;

  late final Animation<double> _animation;

  AnimationController? _fallAnimationController;

  void standBy({required TickerProvider vsync}) {
    _vsync = vsync;
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
      _streamController.add(_currentHeight + _animation.value * _jumpingValue);
    });
  }

  Future<void> drive() async {
    _currentHeight += _animation.value * _jumpingValue;
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
      vsync: _vsync,
      value: _currentHeight,
    )
      ..addListener(() {
        _currentHeight = _fallAnimationController?.value ?? _currentHeight;
        _streamController.add(_currentHeight);
      })
      ..animateTo(
        0.0,
        duration: Duration(milliseconds: 500 * _currentHeight ~/ _maxHeight),
        curve: Curves.linear,
      );
  }
}

///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 16:32
///
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final TweenSequence<double> _jumpingTweenSequence = TweenSequence<double>(
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

abstract class BirdPhysics {
  BirdPhysics({
    required TickerProvider vsync,
    this.builder,
    this.birdSize = const Size.square(50.0),
    this.jumpingValue = 100.0,
  }) {
    _vsync = vsync;
    initializeAnimations();
  }

  late final TickerProvider _vsync;
  final Size birdSize;
  final double jumpingValue;
  final AsyncWidgetBuilder<double>? builder;

  late final MediaQueryData _mediaQuery = MediaQueryData.fromWindow(ui.window);

  double get _maxHeight => _mediaQuery.size.height;

  double _currentHeight = 0.0;

  double get currentHeight => _currentHeight;

  double _lastFallHeight = 0.0;

  final StreamController<double> _heightStreamController =
      StreamController<double>.broadcast();

  Stream<double> get heightStream => _heightStreamController.stream;

  final StreamController<double> _fallDeltaStreamController =
      StreamController<double>.broadcast();

  Stream<double> get fallDeltaStream => _fallDeltaStreamController.stream;

  late final AnimationController _animationController;

  late final Animation<double> _animation;

  AnimationController? _fallAnimationController;

  void initializeAnimations() {
    _animationController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 550),
    );
    _animation = _jumpingTweenSequence.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.slowMiddle,
      ),
    );
    _animation.addListener(() {
      _heightStreamController
          .add(_currentHeight + _animation.value * jumpingValue);
    });
  }

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

  Future<void> fallToGround() async {
    _lastFallHeight = _currentHeight;
    _fallAnimationController = AnimationController.unbounded(
      vsync: _vsync,
      value: _currentHeight,
    )..addListener(() {
        _currentHeight = _fallAnimationController?.value ?? _currentHeight;
        _heightStreamController.add(_currentHeight);
      });
    await _fallAnimationController?.animateTo(
      0.0,
      duration: Duration(milliseconds: 1000 * _currentHeight ~/ _maxHeight),
      curve: Curves.linear,
    );
  }

  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: heightStream,
      initialData: 0.0,
      builder: (BuildContext ctx, AsyncSnapshot<double> data) {
        return Positioned(
          bottom: data.data,
          child:
              builder?.call(context, data) ?? FlutterLogo(size: birdSize.width),
        );
      },
    );
  }
}

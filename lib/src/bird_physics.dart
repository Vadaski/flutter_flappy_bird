///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 16:32
///
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class BirdPhysics {
  BirdPhysics({
    this.builder,
    this.birdSize = const Size.square(70.0),
  });

  final Size birdSize;
  final AsyncWidgetBuilder<double>? builder;

  double _yAxis = 0.0;
  double _time = 0.0;
  // 当前高度
  late double _currentHeight = _initialHeight;
  // 小鸟初始高度
  late double _initialHeight = _yAxis;

  // 对外暴露当前高度
  double get currentHeight => _currentHeight;

  final StreamController<double> _heightStreamController =
      StreamController<double>.broadcast();

  Stream<double> get heightStream => _heightStreamController.stream;

  final GlobalKey _key = GlobalKey();

  RenderBox? get box => _key?.currentContext?.findRenderObject() as RenderBox;

  void drive() {
    _time = 0;
    _initialHeight = _yAxis;
    _heightStreamController.add(_yAxis);
  }

  void startGame(Timer timer) {
    _time += 0.05;
    _currentHeight = -4.9 * _time * _time + 2.8 * _time;
    _yAxis = _initialHeight - _currentHeight;
    _heightStreamController.add(_yAxis);
    if (_yAxis > 1 || _yAxis < -1) {
      timer.cancel();
      resetState();
    }
  }

  void resetState() {
    _yAxis = 0;
    _time = 0;
    _currentHeight = 0;
    _initialHeight = 0;
    _heightStreamController.add(_yAxis);
  }

  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: heightStream,
      initialData: _yAxis,
      builder: (BuildContext ctx, AsyncSnapshot<double> snapshot) {
        final double currentHeight = snapshot.data ?? 0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          alignment: Alignment(0.0, currentHeight),
          child: SizedBox(
            key: _key,
            child: builder?.call(context, snapshot) ??
                FlutterLogo(size: birdSize.width),
          )
        );
      },
    );
  }
}

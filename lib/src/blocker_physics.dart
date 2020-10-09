///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 22:48
///
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'bird_physics.dart';

const double defaultBlockerThickness = 50.0;

typedef BlockerBuilder = Widget Function(
  BuildContext context,
  BlockerPhysics physics,
);

abstract class BlockerPhysics {
  BlockerPhysics({
    required this.bird,
    required this.builder,
    required TickerProvider vsync,
    double? upperEdge,
    double? lowerEdge,
    this.thickness = defaultBlockerThickness,
  }) {
    if (thickness <= 0.0) {
      throw ArgumentError('Do you want a empty blocker? :P');
    }
    _vsync = vsync;
    _initializeEdges(upperEdge, lowerEdge);
    _initializeAnimations();
  }

  final BirdPhysics bird;
  final double thickness;
  late final TickerProvider _vsync;
  final BlockerBuilder builder;

  late final double _upperEdge;

  double get upperEdge => _upperEdge;

  late final double _lowerEdge;

  double get lowerEdge => _lowerEdge;

  late final MediaQueryData _mediaQuery = MediaQueryData.fromWindow(ui.window);

  double _offset = 0.0;

  double get offset => _offset;

  final StreamController<double> _offsetStreamController =
      StreamController<double>.broadcast();

  Stream<double> get heightStream => _offsetStreamController.stream;

  double get _endOffset => _mediaQuery.size.width + thickness;

  bool get isHeightHit {
    final bool hasHitUpperEdge =
        (bird.currentHeight + bird.birdSize.height) < _upperEdge;
    final bool hasHitLowerEdge = bird.currentHeight > _lowerEdge;
    return hasHitUpperEdge && hasHitLowerEdge;
  }

  late final AnimationController _animationController;

  late final Animation<double> _animation;

  void _initializeEdges(double? upperEdge, double? lowerEdge) {
    final double gap = bird.birdSize.height * 1.5;
    final double max = _mediaQuery.size.height;
    if (upperEdge == null && lowerEdge == null) {
      _upperEdge = math.Random().nextDouble() * (max - gap) + gap;
      _lowerEdge = _upperEdge - gap;
    } else if (upperEdge != null && lowerEdge == null) {
      if (upperEdge >= max) {
        throw ArgumentError('Upper edge must be lower than height.');
      } else if (upperEdge < gap) {
        throw ArgumentError('Upper edge must be higher than the gap size.');
      } else {
        _upperEdge = upperEdge;
        _lowerEdge = _upperEdge - gap;
      }
    } else if (upperEdge == null && lowerEdge != null) {
      if (lowerEdge >= max - gap) {
        throw ArgumentError('Lower edge must be lower than height minus gap,');
      } else if (lowerEdge < 0) {
        throw ArgumentError('Lower edge must be higher than the ground.');
      } else {
        _lowerEdge = lowerEdge;
        _upperEdge = _lowerEdge + gap;
      }
    } else {
      final double l = lowerEdge!;
      final double u = upperEdge!;
      if (l >= u) {
        throw ArgumentError('Did you passed the wrong edge?');
      }
      if (u - l <= gap) {
        throw ArgumentError(
          'There is no way that the bird can through this block. :<',
        );
      }
      _upperEdge = u;
      _lowerEdge = l;
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: _vsync,
      duration: const Duration(seconds: 3),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: _endOffset,
    ).animate(_animationController);

    _animation.addListener(() {
      _offset = _animation.value;
      _offsetStreamController.add(_offset);
    });
  }

  Future<void> roll() async {
    _animationController
      ..stop()
      ..reset();
    await _animationController.forward();
  }

  void pause() {
    if (_animationController.isAnimating) {
      _animationController.stop(canceled: false);
    }
  }

  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: heightStream,
      initialData: 0.0,
      builder: (BuildContext ctx, AsyncSnapshot<double> data) {
        return Positioned(
          bottom: data.data,
          child: builder.call(context, this),
        );
      },
    );
  }
}

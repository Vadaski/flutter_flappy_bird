///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/9 17:33
///
import 'package:flutter/material.dart';

import '../src/bird_physics.dart';
import '../src/blocker_physics.dart';

class Blocker extends BlockerPhysics {
  Blocker.random({
    required BirdPhysics bird,
    required TickerProvider vsync,
    double thickness = defaultBlockerThickness,
  }) : super(
          bird: bird,
          builder: _builder,
          vsync: vsync,
          thickness: thickness,
        );

  Blocker.withEdges({
    required BirdPhysics bird,
    required TickerProvider vsync,
    double? upperEdge,
    double? lowerEdge,
    double thickness = defaultBlockerThickness,
  }) : super(
          bird: bird,
          builder: _builder,
          vsync: vsync,
          upperEdge: upperEdge,
          lowerEdge: lowerEdge,
          thickness: thickness,
        );

  static final BlockerBuilder _builder = (
    BuildContext context,
    BlockerPhysics physics,
  ) {
    return SizedBox(
      width: physics.thickness,
      height: double.maxFinite,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            top: 0.0,
            bottom: physics.upperEdge,
            child: _blockerWidget,
          ),
          Positioned.fill(
            top: physics.lowerEdge,
            bottom: 0.0,
            child: _blockerWidget,
          ),
        ],
      ),
    );
  };

  static Widget get _blockerWidget {
    return Container(color: Colors.red);
  }
}

///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 21:56
///
import 'package:flutter/material.dart';

import '../src/bird_physics.dart';

class Bird extends BirdPhysics {
  Bird({
    required TickerProvider vsync,
    AsyncWidgetBuilder<double>? builder,
  }) : super(vsync: vsync, builder: builder);
}

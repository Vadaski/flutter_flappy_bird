///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 21:56
///
import 'package:flutter/material.dart';

import '../src/bird_physics.dart';

// ignore: must_be_immutable
class Bird extends StatelessWidget with BirdPhysics {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: stream,
      initialData: 0.0,
      builder: (_, AsyncSnapshot<double> data) {
        return Positioned(
          bottom: data.data,
          child: FlutterLogo(size: birdSize.width),
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class Blocker {
  int upper;
  int lower;
  double blockerPosition = 0;
  double initPosition;
  StreamController<double> _positionController =
      StreamController<double>.broadcast();

  final GlobalKey _upperKey = GlobalKey();
  final GlobalKey _lowerKey = GlobalKey();

  RenderBox? get upperBox => _upperKey?.currentContext?.findRenderObject() as RenderBox;
  RenderBox? get lowerBox => _lowerKey?.currentContext?.findRenderObject() as RenderBox;

  Blocker(
      {required this.upper,
      required this.lower,
      required this.blockerPosition}):initPosition = blockerPosition;

  void roll() {
    blockerPosition = blockerPosition -= 0.05;
    _positionController.add(blockerPosition);
    if (blockerPosition < -1.5) {
      blockerPosition += 3;
      upper = math.Random.secure().nextInt(10)+2;
      lower = math.Random.secure().nextInt(10)+2;
    }
  }

  void resetState(){
    blockerPosition = initPosition;
    _positionController.add(blockerPosition);
  }

  Widget buildBlocker(BuildContext context) {
    return StreamBuilder<double>(
        stream: _positionController.stream,
        builder: (context, snapshot) {
          return AnimatedAlign(
            alignment: Alignment(blockerPosition, 0),
            duration: const Duration(milliseconds: 0),
            child: Column(
              children: [
                Expanded(
                  key: _upperKey,
                  flex: upper,
                  child: buildSingleBlocker(),
                ),
                const SizedBox(height: 200),
                Expanded(
                  key: _lowerKey,
                  flex: lower,
                  child: buildSingleBlocker(),
                ),
              ],
            ),
          );
        });
  }

  Widget buildSingleBlocker() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
      ),
    );
  }
}

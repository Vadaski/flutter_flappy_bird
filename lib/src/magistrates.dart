import 'package:flutter/material.dart';

class Magistrates {
  Magistrates(this._hitTarget, this._hitSource);
  List<RenderBox> _hitTarget;
  List<RenderBox> _hitSource;

  void updateHitTarget(List<RenderBox> hitTarget) {
    _hitTarget = hitTarget;
  }

  void updateHitSource(List<RenderBox> hitSource) {
    _hitTarget = hitSource;
  }

  bool hitTestEachObject() {
    for (final RenderBox targetBox in _hitTarget) {
      for (final RenderBox sourceBox in _hitSource) {
//        print('sourceBox${sourceBox.globalToLocal(Offset.zero).toString()}');
//        print('targetBox${targetBox.globalToLocal(Offset.zero).toString()}');
        if (hitTest(sourceBox, targetBox)) {
          return true;
        }
      }
    }
    return false;
  }

  bool hitTest(RenderBox box1, RenderBox box2) {
    final box1Offset = box1.globalToLocal(Offset.zero);
    final x = box1.size.width;
    final y = box1.size.height;

    final leftBorder = box1Offset.dx;
    final rightBorder = box1Offset.dx + x;
    final topBorder = box1Offset.dy;
    final bottomBorder = box1Offset.dy - y;

    final box2Offset = box2.globalToLocal(Offset.zero);
    final x2 = box2.size.width;
    final y2 = box2.size.height;

    final leftBorder2 = box2Offset.dx;
    final rightBorder2 = box2Offset.dx + x2;
    final topBorder2 = box2Offset.dy;
    final bottomBorder2 = box2Offset.dy - y2;

    if (leftBorder2 > leftBorder && leftBorder2 < rightBorder) {
      if (topBorder2 > bottomBorder && topBorder2 < topBorder) {
        return true;
      }
      if (bottomBorder2 > bottomBorder && bottomBorder2 < topBorder) {
        return true;
      }
    }

    if (leftBorder > leftBorder2 && leftBorder < rightBorder2) {
      if (topBorder > bottomBorder2 && topBorder < topBorder2) {
        return true;
      }
      if (bottomBorder > bottomBorder2 && bottomBorder < topBorder2) {
        return true;
      }
    }
    return false;
  }

  Widget buildMock() {
    return Positioned(
        child: Container(
      width: 20,
      height: 20,
      color: Colors.lightGreen,
    ));
  }
}

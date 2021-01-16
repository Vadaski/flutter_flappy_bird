import 'package:flutter/material.dart';

class Magistrates {
  // 检测小鸟是否碰撞
  static bool hasHit(
    double upperBound, // 顶部高度限制
    double lowerBound, // 底部高度限制
    double positionToGround, // 当前小鸟位置
    Size birdSize, // 小鸟大小
  ) {
    // 碰撞到上面的柱子
    final bool hitUpperBlocker =
        positionToGround + birdSize.height >= upperBound;
    // 碰撞到下面的柱子
    final bool hitLowerBlocker = positionToGround <= lowerBound;
    if (hitUpperBlocker || hitLowerBlocker) {
      return true;
    }
    // 未碰撞到
    return false;
  }

  // 是否撞到地面
  static bool hasHitGround(double positionToGround) {
    return positionToGround == 0.0;
  }

  // 是否进入碰撞检测区域
  static bool canHitTest(
    double distanceToViewPortLeft, //距离滑动显示区域左部的位置
    double blockerWidth, //柱子宽度
    double birdDistanceToViewPortLeft, //小鸟距离滑动显示区域左部的位置
    double birdWidth, //小鸟大小
  ) {
    if ((distanceToViewPortLeft + blockerWidth) > birdDistanceToViewPortLeft &&
        distanceToViewPortLeft < (birdDistanceToViewPortLeft + birdWidth)) {
      return true;
    }
    return false;
  }
}

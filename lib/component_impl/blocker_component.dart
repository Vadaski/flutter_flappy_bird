//import 'dart:async';
//
//import 'package:flutter/material.dart';
//import 'dart:math' as math;
//
//import 'package:flutterflappybird/src/component.dart';
//import 'package:flutterflappybird/src/score_counter.dart';
//
//class BlockerComponent extends Component<double> {
//  int upper;
//  int lower;
//  double blockerPosition = 0;
//  double initPosition;
//
//  GlobalKey get _upperKey => super.keys[0];
//  GlobalKey get _lowerKey => super.keys[1];
//
//  RenderBox? get upperBox =>
//      _upperKey.currentContext?.findRenderObject() as RenderBox;
//  RenderBox? get lowerBox =>
//      _lowerKey.currentContext?.findRenderObject() as RenderBox;
//
//  bool counted = false;
//
//  BlockerComponent(
//      {required this.upper, required this.lower, required this.blockerPosition})
//      : initPosition = blockerPosition {
//    super.keys..add(GlobalKey())..add(GlobalKey());
//  }
//
//  @override
//  void update(Timer timer) {
//    blockerPosition = blockerPosition -= 0.005;
//    statusReducer.add(blockerPosition);
//    if (blockerPosition < 0 && !counted) {
//      counted = true;
//      counter.getScore();
//    }
//    if (blockerPosition < -1.5) {
//      blockerPosition += 3;
//      upper = math.Random.secure().nextInt(10) + 2;
//      lower = math.Random.secure().nextInt(10) + 2;
//      counted = false;
//    }
//  }
//
//  @override
//  void resetState() {
//    blockerPosition = initPosition;
//    statusReducer.add(blockerPosition);
//    counted = false;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return buildBlocker(context);
//  }
//
//  Widget buildBlocker(BuildContext context) {
//    return StreamBuilder<double>(
//        stream: status,
//        builder: (context, snapshot) {
//          return AnimatedAlign(
//            alignment: Alignment(blockerPosition, 0),
//            duration: const Duration(milliseconds: 0),
//            child: Column(
//              children: [
//                Expanded(
//                  key: _upperKey,
//                  flex: upper,
//                  child: buildSingleBlocker(context, true),
//                ),
//                const SizedBox(height: 200),
//                Expanded(
//                  key: _lowerKey,
//                  flex: lower,
//                  child: buildSingleBlocker(context, false),
//                ),
//              ],
//            ),
//          );
//        });
//  }
//
//  Widget buildSingleBlocker(BuildContext context, bool isTopBlocker) {
//    final double padding = 20;
//    final width = MediaQuery.of(context).size.width;
//    final radius = Radius.circular(12);
//    final edge = Radius.zero;
//    return Container(
//      width: width / 4.5,
//      decoration: BoxDecoration(
//          color: Colors.lightGreen,
//          borderRadius: BorderRadius.only(
//            topLeft: isTopBlocker ? edge : radius,
//            topRight: isTopBlocker ? edge : radius,
//            bottomLeft: isTopBlocker ? radius : edge,
//            bottomRight: isTopBlocker ? radius : edge,
//          ),
//          border: Border.all(color: Colors.green, width: 8)),
//    );
//  }
//}

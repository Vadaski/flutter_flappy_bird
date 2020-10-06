import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HitTestController{
  Timer _timer;

  BuildContext bird;

  HitTestController({
    @required
    this.bird}){
      init();
  }

  init(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      if(bird == null) return;
      RenderBox box = bird.findRenderObject();
      print(box.globalToLocal(Offset.zero).toString());
    });
  }


}
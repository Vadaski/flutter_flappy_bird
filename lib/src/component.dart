import 'dart:async';

import 'package:flutter/material.dart';

abstract class Component<T> {
  final StreamController<T> _statusController = StreamController<T>.broadcast();

  Stream<T> get status => _statusController.stream;
  Sink<T> get statusReducer => _statusController.sink;

  final List<GlobalKey> keys = [];

  int addGlobalKey(GlobalKey key){
    keys.add(key);
    return keys.length - 1;
  }

  RenderBox? getRenderBox(int index) =>
      keys[index].currentContext?.findRenderObject() as RenderBox;

  void update(Timer timer);
}

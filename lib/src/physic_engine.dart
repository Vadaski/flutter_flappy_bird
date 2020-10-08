import 'dart:async';

enum EngineStatus {
  run,
  stop,
}

class PhysicEngine {
  PhysicEngine() {
    init();
  }

  EngineStatus _engineStatus = EngineStatus.stop;

  double _height = 200;

  double _v = 0;

  double _a = -10;

  Timer _engineTimer;

  Timer _flyTimer;

  int _engineTick = 1;

  int _flyTick = 50;

  double _upV = 50;

  double _maxHeight = 0;

  set setMaxHeight(double maxHeight) {
    _maxHeight = maxHeight;
  }

  StreamController _positionController = StreamController<double>.broadcast();

  Stream<double> get position => _positionController.stream
      .where((dynamic event) => event is double)
      .map((dynamic event) => event as double);

//  StreamSink get _positionPublisher => _positionController.sink;

  EngineStatus get status => _engineStatus;

  void init() {
    _height = 200;

    _engineTimer = Timer.periodic(Duration(milliseconds: _engineTick), (timer) {
      _positionController.sink.add(_height);
    });

    _flyTimer = Timer.periodic(Duration(milliseconds: _flyTick), (timer) {
      fly();
    });

    _engineStatus = EngineStatus.run;
  }

  void dispose() {
    _engineTimer?.cancel();
    _flyTimer?.cancel();
    _positionController.close();
  }

  void fly() {
//    print('_v:$_v');

    _v += _a;
    _height += _v;

    if (_height < 0 || _height > _maxHeight) stop();
  }

  void up() {
    _v = _upV;
  }

  void stop() {
    _flyTimer?.cancel();
    _engineTimer?.cancel();

    _engineStatus = EngineStatus.stop;
  }

  void restart() {
    init();
  }
}

import 'package:flutter/material.dart';
import 'package:flutterflappybird/src/hit_test_controller.dart';
import '../src/physic_engine.dart';
import 'bird.dart';

class PlayGround extends StatefulWidget {
  @override
  _PlayGroundState createState() => _PlayGroundState();
}

class _PlayGroundState extends State<PlayGround> {
  final PhysicEngine _engine = PhysicEngine();

  final GlobalKey birdKey = GlobalKey(debugLabel: 'bird');

  final GlobalKey wallKey1 = GlobalKey(debugLabel: 'wall1');

  final GlobalKey wallKey2 = GlobalKey(debugLabel: 'wall2');

  HitTestController hitTestController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      hitTestController = HitTestController(
        bird: birdKey.currentContext,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _engine.setMaxHeight = size.height;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _engine.up,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(width: 100,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      key: wallKey1,
                      height: 200,width: 100,color: Colors.green,),
                    Container(
                      key: wallKey2,
                      height: size.height-200-300,width: 100,color: Colors.green,),
                  ],
                )
              ],
            ),
            Bird(
              key: birdKey,
              engine: _engine,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _engine.status == EngineStatus.run
              ? _engine.stop()
              : _engine.restart();
        },
      ),
    );
  }
}

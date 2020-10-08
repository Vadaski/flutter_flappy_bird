import 'package:flutter/material.dart';
import '../src/physic_engine.dart';

class Bird extends StatefulWidget {
  final Key key;
  final PhysicEngine engine;

  Bird({@required this.engine, this.key}):super(key: key);

  @override
  _BirdState createState() => _BirdState();
}

class _BirdState extends State<Bird> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.engine.position,
        builder: (context, AsyncSnapshot<double> snapshot) {
          if (!snapshot.hasData) return Container();
          final double position = snapshot.data;
//          print('get it: $position');
          return Positioned(bottom: position, left: 100, child: FlutterLogo(
            size: 100,
          ));
        });
  }
}

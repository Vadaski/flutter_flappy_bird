///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/8 18:55
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'new_bird.dart';

class NewPlayground extends StatefulWidget {
  const NewPlayground({Key key}) : super(key: key);

  @override
  _NewPlaygroundState createState() => _NewPlaygroundState();
}

class _NewPlaygroundState extends State<NewPlayground>
    with TickerProviderStateMixin {
  NewBird newBird;

  @override
  void initState() {
    super.initState();
    newBird = NewBird(
      mediaQuery: MediaQueryData.fromWindow(ui.window),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<double>(
        stream: newBird.stream,
        initialData: 0.0,
        builder: (_, AsyncSnapshot<double> data) {
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Center(child: Text(data.data.toString())),
              Positioned(
                bottom: data.data,
                child: FlutterLogo(size: newBird.birdSize.width),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newBird.drive();
        },
      ),
    );
  }
}

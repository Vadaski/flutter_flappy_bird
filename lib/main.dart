import 'package:flutter/material.dart';

import 'widget/bird.dart';

void main() {
  runApp(const MaterialApp(home: Playground()));
}

class Playground extends StatefulWidget {
  const Playground({Key? key}) : super(key: key);

  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> with TickerProviderStateMixin {
  late final Bird newBird = Bird()..standBy(vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: <Widget>[
          Center(
            child: StreamBuilder<double>(
              stream: newBird.stream,
              initialData: 0.0,
              builder: (_, AsyncSnapshot<double> data) {
                return Text(data.data.toString());
              },
            ),
          ),
          newBird,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newBird.drive();
        },
      ),
    );
  }
}

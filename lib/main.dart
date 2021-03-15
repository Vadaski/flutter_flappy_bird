import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/flare_animation.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutterflappybird/component_impl/bird_animation.dart';

const Color COLOR = Color(0xFFDDC0A3);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Game game;

  @override
  void initState() {
    initGame();
    super.initState();
  }

  void initGame() async {
    game = MyGame(size: await Flame.util.initialDimensions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BirdAnimation(),
          Container(
            height: 200,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: game?.widget ??
                  Center(
                    child: CircularProgressIndicator(),
                  ),
            ),
          ),
          Container(
            height: 200,
          ),
        ],
      ),
    );
  }
}

class MyGame extends BaseGame {
  Size size;

  // ignore: sort_constructors_first
  MyGame({this.size}) {
    add(BackGround());
    add(Bird());
  }
}

class BackGround extends Component with Resizable {
  static final Paint _paint = Paint()..color = COLOR;

  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
  }

  @override
  void update(double t) {}
}

class Bird extends Component with Resizable {
  FlareAnimation flareAnimation;
  bool riveLoaded = false;

  Bird() {
    _init();
  }

  void _init() async {
    print('Bird init');
    flareAnimation = await FlareAnimation.load('assets/new_file.riv');
    flareAnimation.updateAnimation('Animation 1');
    flareAnimation.width = 300;
    flareAnimation.height = 300;
    riveLoaded = true;
  }

  @override
  void render(Canvas c) {
    if (riveLoaded) {
      flareAnimation.render(c, x: 50, y: 50);
    }
  }

  @override
  void update(double t) {
    if (riveLoaded) {
      flareAnimation.update(t);
    }
  }
}

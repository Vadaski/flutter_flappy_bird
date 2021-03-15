import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class BirdAnimation extends StatefulWidget {
  @override
  _BirdAnimationState createState() => _BirdAnimationState();
}

class _BirdAnimationState extends State<BirdAnimation> {
  /// The artboard we'll use to play one of its animations
  Artboard _artboard;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  /// Loads dat afrom a Rive file and initializes playback
  void _loadRiveFile() async {
    // Load your Rive data
    final data = await rootBundle.load('assets/new_file1.riv');
    // Create a RiveFile from the binary data
    final file = RiveFile();
    if (file.import(data)) {
      // Get the artboard containing the animation you want to play
      final artboard = file.mainArtboard;
//      artboard.height = 50;
//      artboard.width = 50;
      // Create a SimpleAnimation controller for the animation you want to play
      // and attach it to the artboard
      RiveAnimationController controller = SimpleAnimation('Animation 1');
      artboard.addController(controller);
      // Wrapped in setState so the widget knows the animation is ready to play
      setState(() => _artboard = artboard);
    }
  }

  @override
  Widget build(BuildContext context) => _artboard != null ? Rive(artboard: _artboard) : Container();
}

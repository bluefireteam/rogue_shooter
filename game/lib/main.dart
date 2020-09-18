import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

import './game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.util.setPortrait();
    await Flame.util.fullScreen();
  }
  final size = await Flame.util.initialDimensions();
  final game = SpaceShooterGame(size);
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Stack(
            children: [
              game.widget,
              Positioned(
                  right: 10,
                  top: 50,
                  child: RaisedButton(
                      child: Text('Toggle effect'),
                      onPressed: () {
                        game.toggleEffect();
                      }
                  ),
              ),
            ],
        ),
      ),
    ),
  );
}

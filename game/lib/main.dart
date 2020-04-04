import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

import './game.dart';
import './audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.util.setPortrait();
    await Flame.util.fullScreen();
  }
  final size = await Flame.util.initialDimensions();
  Audio.backgroundMusic();
  runApp(SpaceShooterGame(size).widget);

}

import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

import './game.dart';
import './web_gamepad_controller.dart';

void main() async {
  initGamepad();
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.util.setPortrait();
    await Flame.util.fullScreen();
  }
  final size = await Flame.util.initialDimensions();
  runApp(SpaceShooterGame(size).widget);
}

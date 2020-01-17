import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import './game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO Verify if is web
  //await Flame.util.setPortrait();
  //await Flame.util.fullScreen();
  Size size = await Flame.util.initialDimensions();

  print(size.width);

  runApp(SpaceShooterGame(size).widget);
}

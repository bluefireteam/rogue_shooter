import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import './game.dart';

void main() async {
  await Flame.util.setPortrait();
  await Flame.util.fullScreen();
  Size size = await Flame.util.initialDimensions();

  runApp(SpaceShooterGame(size).widget);
}

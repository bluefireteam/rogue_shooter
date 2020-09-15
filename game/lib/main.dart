import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

import './game.dart';
import 'assets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Assets.load();
  if (!kIsWeb) {
    await Flame.util.setPortrait();
    await Flame.util.fullScreen();
  }
  final size = await Flame.util.initialDimensions();
  runApp(SpaceShooterGame(size).widget);
}

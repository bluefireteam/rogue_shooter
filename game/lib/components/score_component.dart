import 'package:flame/text_config.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import 'dart:ui';

import '../game.dart';

class ScoreComponent extends TextComponent with HasGameRef<SpaceShooterGame> {
  ScoreComponent() : super(
      "Score 0",
      config: TextConfig(color: Color(0xffffffff))
  ) {
    x = y = 5;
  }

  @override
  void update(double dt) {
    text = "Score ${gameRef.score}";
  }
}

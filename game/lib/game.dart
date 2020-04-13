import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/time.dart';
import 'package:flame/components/timer_component.dart';
import 'package:flutter/material.dart';

import './components/player_component.dart';
import './components/enemy_creator.dart';
import './components/star_background_creator.dart';
import './components/score_component.dart';
import './audio.dart';

class SpaceShooterGame extends BaseGame with PanDetector {

  PlayerComponent player;
  StarBackGroundCreator starBackGroundCreator;

  int score = 0;
  bool _musicStarted = false;

  SpaceShooterGame(Size size) {
    this.size = size;
    _initPlayer();

    add(EnemyCreator());
    add(starBackGroundCreator = StarBackGroundCreator(size));
    starBackGroundCreator.init();

    add(ScoreComponent());
  }

  void _initPlayer() {
    add(player = PlayerComponent());
  }

  @override
  void onPanStart(_) {
    if (!_musicStarted) {
      _musicStarted = true;
      Audio.backgroundMusic();
    }
    player?.beginFire();
  }

  @override
  void onPanEnd(_) {
    player?.stopFire();
  }

  @override
  void onPanCancel() {
    player?.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    player?.move(details.delta.dx, details.delta.dy);
  }

  void increaseScore() {
    score++;
  }

  void playerTakeHit() {
    player.takeHit();

    player = null;

    score = 0;

    add(
        TimerComponent(
            Timer(1, callback: _initPlayer)
            ..start()
        )
    );
  }
}

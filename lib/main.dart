import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/time.dart';

import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.util.setPortrait();
  await Flame.util.fullScreen();
  final screenSize = await Flame.util.initialDimensions();

  runApp(RogueShooterGameWidget(screenSize: screenSize));
}

class RogueShooterGameWidget extends StatelessWidget {
  final Size screenSize;

  RogueShooterGameWidget({ this.screenSize });

  @override
  Widget build(BuildContext context) {
    final game = RogueShooterGame(screenSize);

    return GestureDetector(
        child: Container(
            color: Color(0xFF000000),
            child: game.widget
        ),
        onPanDown: (_) {
          game.startShooting();
        },
        onPanCancel: () {
          game.stopShooting();
        },
        onPanEnd: (_) {
          game.stopShooting();
        },
        onPanUpdate: (DragUpdateDetails details) {
          game.movePlayer(details.delta);
        },
    );
  }
}

class RogueShooterGame extends Game {

  static const double shoot_speed = -600.0;
  static const double enemy_speed = 50.0;

  static Random random = Random();

  Size _screenSize;
  Rect _player;

  List<Rect> _shoots = [];
  List<Rect> _enemies = [];

  Timer _shooter;
  Timer _enemySpawmer;

  static Paint _white = Paint()..color = const Color(0xFFFFFFFF);

  RogueShooterGame(this._screenSize) {
    _player = Rect.fromLTWH(_screenSize.width / 2 - 25, _screenSize.height - 75, 50, 50);

    _shooter = Timer(0.3, repeat: true, callback: () {
      _createShoot();
    });

    _enemySpawmer = Timer(2, repeat: true, callback: () {
      _createEnemy();
    });
    _enemySpawmer.start();
  }

  void _createEnemy() {
    _enemies.add(Rect.fromLTWH(
            max(20, random.nextDouble() * _screenSize.width - 20),
            0,
            20,
            20)
    );
  }

  void _createShoot() {
    _shoots.add(Rect.fromLTWH(_player.left + 20, _player.top, 10, 20));
  }

  void startShooting() {
    _shooter.start();
  }

  void stopShooting() {
    _shooter.stop();
  }

  void movePlayer(Offset offset) {
    final newPosition = _player.translate(offset.dx, offset.dy);
    if (newPosition.left >= 0 && newPosition.right <= _screenSize.width)
      _player = newPosition;
  }

  @override
  void update(double dt) {
    _shooter.update(dt);
    _enemySpawmer.update(dt);

    for (var i = 0; i < _shoots.length; i++) {
      _shoots[i] = _shoots[i].translate(0, shoot_speed * dt);
    }

    _shoots.removeWhere((rect) => rect.bottom <= 0);

    for (var i = 0; i < _enemies.length; i++) {
      _enemies[i] = _enemies[i].translate(0, enemy_speed * dt);
    }
    _enemies.removeWhere((enemy) {
      return enemy.top >= _screenSize.height || _shoots.firstWhere(
          (shoot) => shoot.overlaps(enemy),
          orElse: () => null
      ) != null;
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(_player, _white);

    _shoots.forEach((rect) {
      canvas.drawRect(rect, _white);
    });

    _enemies.forEach((rect) {
      canvas.drawRect(rect, _white);
    });
  }
}

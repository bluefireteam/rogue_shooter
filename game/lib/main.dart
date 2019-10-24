import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/time.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/animation.dart' as FlameAnimation;

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

class Explosion {
  Rect rect;
  FlameAnimation.Animation animation;
}

class Star {
  Rect rect;
  FlameAnimation.Animation animation;
}

class CollideableAnimation {
  Rect rect;
  FlameAnimation.Animation animation;
  List<CollideableAnimation> collidingWith = [];

  void resetCollisions() {
    collidingWith.clear();
  }
}

class RogueShooterGame extends Game {

  static const double shoot_speed = -600.0;
  static const double enemy_speed = 50.0;
  static const double star_speed = 10.0;

  static Random random = Random();

  Size _screenSize;
  Rect _player;
  FlameAnimation.Animation _playerAnimation;

  List<CollideableAnimation> _shoots = [];
  List<CollideableAnimation> _enemies = [];
  List<Explosion> _explosions = [];
  List<Star> _stars = [];

  SpriteSheet _starsSpritesheet;

  Timer _shooter;
  Timer _enemySpawmer;
  Timer _starSpawmer;

  RogueShooterGame(this._screenSize) {
    _player = Rect.fromLTWH(_screenSize.width / 2 - 25, _screenSize.height - 75, 50, 75);

    _shooter = Timer(0.2, repeat: true, callback: () {
      _createShoot();
    });

    _enemySpawmer = Timer(1, repeat: true, callback: () {
      _createEnemy();
    });
    _enemySpawmer.start();

    final starGapTime = (_screenSize.height / 10) / star_speed;
    _starSpawmer = Timer(starGapTime, repeat: true, callback: () {
      _createRowOfStars(0);
    });
    _starSpawmer.start();

    _playerAnimation = FlameAnimation.Animation.sequenced("player.png", 4, textureWidth: 32, textureHeight: 48);

    _starsSpritesheet = SpriteSheet(imageName: "stars.png", textureWidth: 9, textureHeight: 9, rows: 4, columns: 4);

    _createInitialStars();
  }

  void _createEnemy() {
    _enemies.add(
        CollideableAnimation()
        ..animation = FlameAnimation.Animation.sequenced("enemy.png", 4, textureWidth: 16, textureHeight: 16)
        ..rect =Rect.fromLTWH(
            max(25, random.nextDouble() * _screenSize.width - 25),
            0,
            25,
            25)
    );
  }

  void _createShoot() {
    _shoots.add(CollideableAnimation()
        ..animation = FlameAnimation.Animation.sequenced("bullet.png", 4, textureWidth: 8, textureHeight: 16)
        ..rect = Rect.fromLTWH(_player.left + 20, _player.top, 10, 20)
    );
  }

  void _createExplosiongAt(double x, double y) {
    final animation = FlameAnimation.Animation.sequenced("explosion.png", 6, textureWidth: 32, textureHeight: 32, stepTime: 0.05)
        ..loop = false;

    _explosions.add(
        Explosion()
        ..animation = animation
        ..rect = Rect.fromLTWH(x - 25, y - 25, 50, 50)
    );
  }

  void _createStarAt(double x, double y) {
    final animation = _starsSpritesheet.createAnimation(random.nextInt(3), to: 4)
        ..variableStepTimes = [
          max(20, 100 * random.nextDouble()),
          0.1, 0.1, 0.1
        ];

    _stars.add(
        Star()
        ..rect = Rect.fromLTWH(x, y, 20, 20)
        ..animation = animation
    );
  }

  void _createRowOfStars(double y) {
    double starGap = _screenSize.width / 3;

    for (var i = 0; i < 3; i++) {
      _createStarAt(
          starGap * i + (random.nextDouble() * starGap),
          y + (random.nextDouble() * 20)
      );
    }
  }

  void _createInitialStars() {
    double rows = _screenSize.height / 10;

    for (var i = 0; i < 10; i++) {
      _createRowOfStars(i * rows);
    }
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
    _playerAnimation.update(dt);
    _starSpawmer.update(dt);

    for (var i = 0; i < _stars.length; i++) {
      _stars[i].rect = _stars[i].rect.translate(0, star_speed * dt);
      _stars[i].animation.update(dt);
    }

    for (var i = 0; i < _enemies.length; i++) {
      _enemies[i].resetCollisions();
      _enemies[i].animation.update(dt);
      _enemies[i].rect = _enemies[i].rect.translate(0, enemy_speed * dt);
    }
    for (var i = 0; i < _shoots.length; i++) {
      _shoots[i].resetCollisions();
      _shoots[i].animation.update(dt);
      _shoots[i].rect = _shoots[i].rect.translate(0, shoot_speed * dt);
    }

    // Check collisions of shoots with enemies
    _shoots.forEach((shoot) {
      _enemies.forEach((enemy) {
        if (shoot.rect.overlaps(enemy.rect)) {
          shoot.collidingWith.add(enemy);
          enemy.collidingWith.add(shoot);

          _createExplosiongAt(enemy.rect.center.dx, enemy.rect.center.dy);
        }
      });
    });

    _explosions.forEach((explosion) {
      explosion.animation.update(dt);
    });

    // Remove and enemies that are out of the screen or has been destroyed
    _shoots.removeWhere((shoot) => shoot.collidingWith.isNotEmpty || shoot.rect.bottom <= 0);
    _enemies.removeWhere((enemy) => enemy.collidingWith.isNotEmpty || enemy.rect.top >= _screenSize.height);

    // Remove finished explosions
    _explosions.removeWhere((explosion) => explosion.animation.isLastFrame);

    // Remove stars out of the screen
    _stars.removeWhere((star) => star.rect.top >= _screenSize.height);
  }

  @override
  void render(Canvas canvas) {
    _stars.forEach((star) {
      if (star.animation.loaded()) {
        star.animation.getSprite().renderRect(canvas, star.rect);
      }
    });

    if (_playerAnimation.loaded())
      _playerAnimation.getSprite().renderRect(canvas, _player);

    _shoots.forEach((shoot) {
      if (shoot.animation.loaded())
        shoot.animation.getSprite().renderRect(canvas, shoot.rect);
    });

    _enemies.forEach((enemy) {
      if (enemy.animation.loaded())
        enemy.animation.getSprite().renderRect(canvas, enemy.rect);
    });

    _explosions.forEach((explosion) {
      if (explosion.animation.loaded()) {
        explosion.animation.getSprite().renderRect(canvas, explosion.rect);
      }
    });
  }
}

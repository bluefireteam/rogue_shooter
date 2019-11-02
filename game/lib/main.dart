import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/time.dart';
import 'package:flame/flame.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flame/spritesheet.dart';

import 'dart:math';

void main() async {
  await Flame.util.setPortrait();
  await Flame.util.fullScreen();
  Size size = await Flame.util.initialDimensions();

  runApp(GameWidget(size));
}


class GameWidget extends StatelessWidget {
  final Size size;

  GameWidget(this.size);

  @override
  Widget build(BuildContext context) {

    final game = SpaceShooterGame(size);
    return GestureDetector(
        onPanStart: (_) {
          game.beginFire();
        },
        onPanEnd: (_) {
          game.stopFire();
        },
        onPanCancel: () {
          game.stopFire();
        },
        onPanUpdate: (DragUpdateDetails details) {
          game.onPlayerMove(details.delta);
        },
        child: Container(
            color: Color(0xFF000000),
            child: game.widget
        ),
    );
  }
}

class AnimationCollidableGameObject extends AnimationGameObject {
  List<AnimationCollidableGameObject> collidingObjects = [];
}

class AnimationGameObject {
  Rect position;
  FlameAnimation.Animation animation;

  void render(Canvas canvas) {
    if (animation.loaded()) {
      animation.getSprite().renderRect(canvas, position);
    }
  }

  void update(double dt) {
    animation.update(dt);
  }
}

class SpaceShooterGame extends Game {

  final Size screenSize;

  Random random = Random();

  static const enemy_speed = 150;
  static const shoot_speed = -500;
  static const star_speed = 10;

  AnimationGameObject player;

  Timer enemyCreator;
  Timer shootCreator;
  Timer starCreator;

  List<AnimationCollidableGameObject> enemies = [];
  List<AnimationCollidableGameObject> shoots = [];
  List<AnimationCollidableGameObject> explosions = [];
  List<AnimationCollidableGameObject> stars = [];

  SpriteSheet starsSpritesheet;

  SpaceShooterGame(this.screenSize) {
    player = AnimationGameObject()
        ..position = Rect.fromLTWH(100, 500, 50, 75)
        ..animation = FlameAnimation.Animation.sequenced("player.png", 4, textureWidth: 32, textureHeight: 48);

    enemyCreator = Timer(1.0, repeat: true, callback: () {
      enemies.add(
          AnimationCollidableGameObject()
          ..animation = FlameAnimation.Animation.sequenced("enemy.png", 4, textureWidth: 16, textureHeight: 16)
          ..position = Rect.fromLTWH((screenSize.width - 25) * random.nextDouble(), 0, 25, 25)
      );
    });
    enemyCreator.start();

    shootCreator = Timer(0.5, repeat: true, callback: () {
      shoots.add(
          AnimationCollidableGameObject()
          ..animation = FlameAnimation.Animation.sequenced("bullet.png", 4, textureWidth: 8, textureHeight: 16)
          ..position = Rect.fromLTWH(
              player.position.left + 20,
              player.position.top - 20,
              10,
              20
          )
      );
    });

    final starGapTime = (screenSize.height / 10) / star_speed;

    starCreator = Timer(starGapTime, repeat: true, callback: () {
      createRowOfStars(0);
    });
    starCreator.start();

    starsSpritesheet = SpriteSheet(
        imageName: "stars.png",
        textureWidth: 9,
        textureHeight: 9,
        rows: 4,
        columns: 4
    );

    createInitialStarts();
  }

  void onPlayerMove(Offset delta) {
    player.position = player.position.translate(delta.dx, delta.dy);
  }

  void beginFire() {
    shootCreator.start();
  }

  void stopFire() {
    shootCreator.stop();
  }

  void creatExplosionAt(double x, double y) {
    final animation = FlameAnimation.Animation.sequenced("explosion.png", 6, textureWidth: 32, textureHeight: 32, stepTime: 0.05)
        ..loop = false;

    explosions.add(
        AnimationCollidableGameObject()
        ..animation = animation
        ..position = Rect.fromLTWH(x - 25, y - 25, 50, 50)
    );
  }

  void createStarAt(double x, double y) {
    final animation = starsSpritesheet.createAnimation(random.nextInt(3), to: 4)
        ..variableStepTimes = [
          max(20, 100 * random.nextDouble()),
          0.1, 0.1, 0.1
        ];

    stars.add(
        AnimationCollidableGameObject()
        ..position = Rect.fromLTWH(x, y, 20, 20)
        ..animation = animation
    );
  }

  void createRowOfStars(double y) {
    final gapSize = 6;
    double starGap = screenSize.height / gapSize;

    for (var i = 0; i < gapSize; i++) {
      createStarAt(
          starGap * i + (random.nextDouble() * starGap),
          y + (random.nextDouble() * 20)
      );
    }
  }

  void createInitialStarts() {
    final gapSize = 10;
    double rows = screenSize.height / gapSize;

    for (var i = 0; i < gapSize;  i++) {
      createRowOfStars(i * rows);
    }
  }

  @override
  void update(double dt) {
    enemyCreator.update(dt);
    shootCreator.update(dt);
    starCreator.update(dt);

    player.update(dt);

    enemies.forEach((enemy) {
      enemy.update(dt);
      enemy.position = enemy.position.translate(0, enemy_speed * dt);
    });

    shoots.forEach((shoot) {
      shoot.update(dt);
      shoot.position = shoot.position.translate(0, shoot_speed * dt);
    });


    stars.forEach((star) {
      star.update(dt);
      star.position = star.position.translate(0, star_speed * dt);
    });

    explosions.forEach((explosion) {
      explosion.update(dt);
    });

    shoots.forEach((shoot) {
      enemies.forEach((enemy) {
        if (shoot.position.overlaps(enemy.position)) {
          creatExplosionAt(shoot.position.left, shoot.position.top);
          shoot.collidingObjects.add(enemy);
          enemy.collidingObjects.add(shoot);
        }
      });
    });

    stars.removeWhere((star) => star.position.top >= screenSize.height);

    enemies.removeWhere((enemy) {
      return enemy.position.top >= screenSize.height || enemy.collidingObjects.isNotEmpty;
    });
    shoots.removeWhere((shoot) {
      return shoot.position.bottom <= 0 || shoot.collidingObjects.isNotEmpty;
    });

    explosions.removeWhere((explosion) => explosion.animation.isLastFrame);
  }

  @override
  void render(Canvas canvas) {
    player.render(canvas);

    enemies.forEach((enemy) {
      enemy.render(canvas);
    });

    shoots.forEach((shoot) {
      shoot.render(canvas);
    });

    explosions.forEach((explosion) {
      explosion.render(canvas);
    });

    stars.forEach((star) {
      star.render(canvas);
    });
  }
}


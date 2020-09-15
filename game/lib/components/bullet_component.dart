import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../game.dart';
import './enemy_component.dart';

import '../assets.dart';

class BulletComponent extends AnimationComponent with HasGameRef<SpaceShooterGame>{
  static const bullet_speed = -500;

  bool destroyed = false;

  BulletComponent(double x, double y): super(10, 20, Assets.atlas.getAnimation('bullet')) {
      this.x = x;
      this.y = y;
    }

  @override
  void update(double dt) {
    super.update(dt);

    y += bullet_speed * dt;

    gameRef.components
        .whereType<EnemyComponent>()
        .forEach((enemy) {
          if (enemy.toRect().overlaps(toRect())) {
            destroyed = true;

            enemy.takeHit();
          }
        });
  }

  @override
  bool destroy() => destroyed || toRect().bottom <= 0;
}

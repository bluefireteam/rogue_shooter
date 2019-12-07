import 'package:flame/components/animation_component.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../game.dart';

class StarComponent extends AnimationComponent with HasGameRef<SpaceShooterGame>{

  static const star_speed = 10;

  bool destroyed = false;

  StarComponent(double x, double y, Animation animation):
    super(20, 20, animation) {
      this.x = x;
      this.y = y;
    }

  @override
  void update(double dt) {
    super.update(dt);

    y += dt * star_speed;
  }

  @override
  bool destroy() => y >= gameRef.size.height;
}

import 'package:flame/components/animation_component.dart';
import 'package:flame/animation.dart';

class ExplosionComponent extends AnimationComponent {

  ExplosionComponent(double x, double y): super(
      50,
      50,
      Animation.sequenced("explosion.png", 6, textureWidth: 32, textureHeight: 32, stepTime: 0.05),
      destroyOnFinish: true
  ) {
      this.x = x;
      this.y = y;
    }
}


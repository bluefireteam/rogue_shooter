import 'package:flame/components/animation_component.dart';

import '../audio.dart';
import '../assets.dart';

class ExplosionComponent extends AnimationComponent {

  ExplosionComponent(double x, double y): super(
      50,
      50,
      Assets.atlas.getAnimation('explosion'),
      destroyOnFinish: true
  ) {
      Audio.explosion();
      this.x = x;
      this.y = y;
    }
}


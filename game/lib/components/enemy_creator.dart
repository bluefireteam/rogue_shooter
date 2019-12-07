import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/time.dart';

import 'dart:ui';
import 'dart:math';

import '../game.dart';

import './enemy_component.dart';

class EnemyCreator extends Component with HasGameRef<SpaceShooterGame>{

  Timer enemyCreator;

  Random random = Random();

  EnemyCreator() {
    enemyCreator = Timer(1.0, repeat: true, callback: () {
      gameRef.add(EnemyComponent((gameRef.size.width - 25) * random.nextDouble(), 0));
    });
    enemyCreator.start();
  }

  @override
  void update(double dt) {
    enemyCreator.update(dt);
  }

  @override
  void render(Canvas canvas) { }
}

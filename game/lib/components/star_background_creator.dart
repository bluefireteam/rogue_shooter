import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/time.dart';
import 'package:flame/spritesheet.dart';

import 'dart:ui';
import 'dart:math';

import '../game.dart';
import './star_component.dart';

class StarBackGroundCreator extends Component with HasGameRef<SpaceShooterGame>{
  static const star_speed = 10;
  final gapSize = 12;

  Timer starCreator;
  SpriteSheet starsSpritesheet;
  Random random = Random();

  Size screenSize;

  StarBackGroundCreator(this.screenSize);

  void init() {
    starsSpritesheet = SpriteSheet(
        imageName: "stars.png",
        textureWidth: 9,
        textureHeight: 9,
        rows: 4,
        columns: 4
    );

    final starGapTime = (screenSize.height / gapSize) / star_speed;

    starCreator = Timer(starGapTime, repeat: true, callback: () {
      _createRowOfStars(0);
    });
    starCreator.start();

    _createInitialStars();
  }

  void _createStarAt(double x, double y) {
    final animation = starsSpritesheet.createAnimation(random.nextInt(3), to: 4)
        ..variableStepTimes = [
          max(20, 100 * random.nextDouble()),
          0.1, 0.1, 0.1
        ];

    gameRef.add(StarComponent(x, y, animation));
  }
  _createRowOfStars(double y) {
    final gapSize = 6;
    double starGap = screenSize.width / gapSize;

    for (var i = 0; i < gapSize; i++) {
      _createStarAt(
          starGap * i + (random.nextDouble() * starGap),
          y + (random.nextDouble() * 20)
      );
    }
  }

  void _createInitialStars() {
    double rows = screenSize.height / gapSize;

    for (var i = 0; i < gapSize;  i++) {
      _createRowOfStars(i * rows);
    }
  }

  @override
  void update(double dt) {
    starCreator.update(dt);
  }

  @override
  void render(Canvas canvas) {}
}

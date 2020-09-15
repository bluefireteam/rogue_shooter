import 'package:flame_fire_atlas/flame_fire_atlas.dart';

class Assets {
  static FireAtlas atlas;

  static Future<void> load() async {
    atlas = await FireAtlas.fromAsset('atlas/rogue_shooter.fa');
  }
}

import 'package:flame/flame.dart';

class Audio {
  static void explosion() {
    Flame.audio.play('small-explosion.wav');
  }

  static void backgroundMusic() {
    Flame.audio.loopLongAudio('space-idea.mp3');
  }
}

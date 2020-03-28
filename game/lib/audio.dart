import 'package:audioplayers/audio_cache.dart';

class Audio {
  static final AudioCache cache = AudioCache(prefix: 'audio/');

  static void explosion() {
    cache.play('small-explosion.wav');
  }
}
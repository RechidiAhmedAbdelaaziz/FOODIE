import 'package:injectable/injectable.dart';
import 'package:audioplayers/audioplayers.dart';

@lazySingleton
class SoundService {
  final _player = AudioPlayer();

  void playSound(String soundPath) {
    _player.play(AssetSource(soundPath));
  }
}

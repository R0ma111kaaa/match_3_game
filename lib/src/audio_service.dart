import 'package:flame_audio/flame_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPool clickPool;
  late AudioPool dropPool;
  late AudioPool winPool;
  late AudioPool losePool;
  late AudioPool whooshPool;

  Future<void> init() async {
    clickPool = await FlameAudio.createPool('digital_click.wav', maxPlayers: 8);
    whooshPool = await FlameAudio.createPool('whoosh.mp3', maxPlayers: 8);
    dropPool = await FlameAudio.createPool('coin.mp3', maxPlayers: 8);
    winPool = await FlameAudio.createPool('win.mp3', maxPlayers: 1);
    losePool = await FlameAudio.createPool('lose.mp3', maxPlayers: 1);
  }

  void playClick() {
    clickPool.start();
  }

  void playDrop() {
    dropPool.start();
  }

  void playWin() {
    winPool.start();
  }

  void playLose() {
    losePool.start();
  }

  void playWhoosh() {
    whooshPool.start();
  }
}

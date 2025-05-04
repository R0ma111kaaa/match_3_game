import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache.loadAll([
    'coin.mp3',
    'digital_click.wav',
    'digital.wav',
    'lose.mp3',
    'win.mp3',
  ]);
  runApp(GameWidget(game: Match3Game()));
}

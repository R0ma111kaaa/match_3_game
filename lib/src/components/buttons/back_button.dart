import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class BackButton extends IconButton with HasGameRef<Match3Game> {
  BackButton({required super.size})
    : super(color: GameColors.grey, tapColor: GameColors.black);

  @override
  Future<void> onLoad() async {
    image = await Flame.images.load("back.png");
    action = () => gameRef.router.pop();
    return super.onLoad();
  }
}

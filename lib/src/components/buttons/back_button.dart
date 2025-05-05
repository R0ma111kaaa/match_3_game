import 'dart:async';
import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/tools/sprite_cache.dart';

class BackButton extends IconButton with HasGameRef<Match3Game> {
  BackButton({required super.size})
    : super(color: GameColors.white, tapColor: GameColors.red);

  @override
  Future<void> onLoad() async {
    sprite = await SpriteCache.getSprite("back.png");
    action = () => gameRef.router.pushReplacementNamed("home");
    return super.onLoad();
  }
}

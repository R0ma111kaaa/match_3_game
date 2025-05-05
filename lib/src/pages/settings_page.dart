import 'dart:async';

import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/tools/sprite_cache.dart';

class SettingsPage extends Component with HasGameRef<Match3Game> {
  @override
  Future<void> onLoad() async {
    Sprite backSprite = await SpriteCache.getSprite("settings_background.jpg");
    addAll([
      SpriteComponent(sprite: backSprite, size: game.size),
      BackButton(size: Globals.defaultButtonSize)
        ..position = Globals.defaultButtonSize,
    ]);
    return super.onLoad();
  }
}

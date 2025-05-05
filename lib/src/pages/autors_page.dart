import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/cupertino.dart';
import 'package:match_3_game/src/components/background_component.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/tools/sprite_cache.dart';

class AutorsPage extends Component with HasGameRef<Match3Game> {
  @override
  Future<void> onLoad() async {
    Vector2 screenSize = game.size;
    Sprite backSprite = await SpriteCache.getSprite("settings_background.jpg");
    addAll([
      SpriteComponent(sprite: backSprite, size: game.size),
      AuthorsBlock(Globals.authors)..position = Vector2(game.size.x / 2, 100),
      BackButton(size: Globals.defaultButtonSize)
        ..position = Globals.defaultButtonSize,
    ]);
    return super.onLoad();
  }
}

class AuthorsBlock extends PositionComponent with HasGameRef<Match3Game> {
  AuthorsBlock(this.authors);

  List<String> authors;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topCenter;
    size = Vector2(game.size.x * Globals.baseCoef, 150);
    add(
      ColumnComponent(
        children: List.generate(
          authors.length,
          (i) => TextComponent(
            text: authors[i],
            textRenderer: TextPaint(
              style: TextStyle(
                fontSize: size.x / 15,
                fontWeight: FontWeight.bold,
                fontFamily: "RuneScape",
              ),
            ),
          ),
        ),
      ),
    );
    return super.onLoad();
  }
}

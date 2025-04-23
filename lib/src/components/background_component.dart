import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/sprite_cache.dart';
import 'package:match_3_game/src/tools/time_value_changer.dart';

class DimensionBackground extends Component
    with HasGameRef<Match3Game>, HasWorldReference<GameWorld> {
  // фон первой страницы - совокупность движущихся декораций
  // и статичной картинки в зависимотсти от текущего выбранного мира
  late SpriteComponent backgroundSprite;

  @override
  Future<void> onLoad() async {
    priority = -1;
    _load();
  }

  Future<void> change() async {
    _removeCurrent();
    _load(true);
  }

  Future<void> _removeCurrent() async {
    SpriteComponent previousBackgroundSprite = backgroundSprite;
    await Future.delayed(
      Duration(milliseconds: toMiliseconds(Globals.backgroundLoadDuration)),
    );
    previousBackgroundSprite.removeFromParent();
    return;
  }

  Future<void> _load([bool animate = false]) async {
    Sprite sprite = await SpriteCache.getSprite(
      game.currentDimension.backgroundFilename,
    );
    backgroundSprite = SpriteComponent(sprite: sprite, size: gameRef.size);
    if (animate) {
      backgroundSprite.opacity = 0;
      backgroundSprite.add(
        OpacityEffect.to(
          1,
          EffectController(duration: Globals.backgroundLoadDuration),
        ),
      );
    }
    addAll([backgroundSprite]);
    return;
  }
}

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';

class LevelButton extends TextButton with HasWorldReference<GameWorld> {
  final int levelId;
  final bool completed;

  LevelButton({
    required super.size,
    required this.levelId,
    required this.completed,
    required super.color,
    required super.tapColor,
  }) : super(textString: levelId.toString());

  @override
  Future<void> onLoad() async {
    super.onLoad();
    scale = Vector2.zero();
    anchor = Anchor.center;
    action = () => world.startLevel(levelId);
    add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(
          duration: Globals.tileResizeDuration,
          startDelay: Globals.minDelay * levelId,
        ),
      ),
    );
  }

  void removeFromTheGrid() {
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(
          duration: Globals.tileResizeDuration,
          startDelay: Globals.minDelay * levelId,
        ),
        onComplete: removeFromParent,
      ),
    );
  }
}

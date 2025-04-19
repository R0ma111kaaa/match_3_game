import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';

class LevelButton extends TextButton with HasWorldReference<GameWorld> {
  final int levelId;

  LevelButton({
    required this.levelId,
    required super.size,
    required bool completed,
    super.fontSize,
  }) : super(
         textString: levelId.toString(),
         color:
             completed
                 ? GameColors.completedLevelColor
                 : GameColors.uncompletedLevelColor,
         tapColor: GameColors.red,
       );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    action = world.field.regenerate;
  }
}

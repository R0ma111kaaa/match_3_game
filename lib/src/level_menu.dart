import 'dart:async';
import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/level_button.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';

class LevelMenu extends PositionComponent
    with HasGameRef<Match3Game>, HasWorldReference<GameWorld> {
  late Vector2 levelButtonSize;
  late int levelNum;

  LevelMenu(size) : super(size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    levelNum = world.currentDimension.levels.length;
    levelButtonSize = getButtonSize();

    anchor = Anchor.topCenter;

    for (int i = 0; i < levelNum; i++) {
      add(
        LevelButton(
          size: levelButtonSize,
          completed: false,
          levelId: i,
          fontSize: levelButtonSize.x / 2,
        )..position = getButtonPosition(i),
      );
    }
  }

  Vector2 getButtonPosition(int levelId) {
    int row = levelId ~/ Globals.levelsPerRow;
    int column = levelId % Globals.levelsPerRow;
    Vector2 position = Vector2(
      levelButtonSize.x * (column) + (column + 1) * Globals.levelButtonOffset,
      levelButtonSize.y * (row) + (row + 1) * Globals.levelButtonOffset,
    );
    return position;
  }

  Vector2 getButtonSize() {
    Vector2 buttonSize = Vector2(
      (size.x - Globals.levelButtonOffset * (Globals.levelsPerRow + 1)) /
          Globals.levelsPerRow,
      (size.x - Globals.levelButtonOffset * (Globals.levelsPerRow + 1)) /
          Globals.levelsPerRow,
    );
    return buttonSize;
  }
}

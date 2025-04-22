import 'dart:async';
import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/level_button.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';

class LevelMenu extends PositionComponent
    with HasGameRef<Match3Game>, HasWorldReference<GameWorld> {
  late Vector2 levelButtonSize;
  List<LevelButton> levelButtons = [];
  int levelNum = 0;

  LevelMenu(size) : super(size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.topCenter;
    levelButtonSize = getButtonSize();

    regenerate();
  }

  void regenerate() {
    int previousLevelNum = levelNum;
    levelNum = world.currentDimension.levels.length;

    int delta = levelNum - previousLevelNum;
    if (delta < 0) {
      for (int i = previousLevelNum; i > levelNum; i--) {
        levelButtons.removeLast().removeFromTheGrid();
      }
    } else if (delta > 0) {
      for (int i = previousLevelNum; i < levelNum; i++) {
        LevelButton newButton = LevelButton(
          size: levelButtonSize,
          completed: false,
          levelId: i,
        )..position = getButtonPosition(i);
        add(newButton);
        levelButtons.add(newButton);
      }
    }
  }

  Vector2 getButtonPosition(int levelId) {
    int row = levelId ~/ Globals.levelsPerRow;
    int column = levelId % Globals.levelsPerRow;
    Vector2 position = Vector2(
      levelButtonSize.x * (column) +
          (column + 1) * Globals.levelButtonOffset +
          levelButtonSize.x / 2,
      levelButtonSize.y * (row) +
          (row + 1) * Globals.levelButtonOffset +
          levelButtonSize.y / 2,
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

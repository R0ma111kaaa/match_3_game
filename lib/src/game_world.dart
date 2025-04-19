import 'dart:async';
import 'package:flame/components.dart';
import 'package:match_3_game/src/components/background_component.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart'
    show BackButton;
import 'package:match_3_game/src/components/buttons/direction_changer_button.dart';
import 'package:match_3_game/src/direction.dart';
import 'package:match_3_game/src/field.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/level_menu.dart';

class GameWorld extends World with HasGameRef<Match3Game> {
  late final Field field;
  late final LevelMenu levelMenu;
  late final DirectionChangerButton previousDir;
  late final DirectionChangerButton nextDir;

  late final List<Dimension> dimensions;
  late Dimension currentDimension;

  void changeDirection(int delta) {
    int currentIndex = dimensions.indexOf(currentDimension);
    int newIndex = (currentIndex + delta) % dimensions.length;
    if (newIndex < 0) {
      newIndex += dimensions.length;
    }
    currentDimension = dimensions[newIndex];

    field.regenerate();
  }

  @override
  Future<void> onLoad() async {
    dimensions = gameRef.dimensions;
    currentDimension = dimensions[0];
    addAll([
      HomePageBackground(),
      field = Field(
        size: Vector2.all(gameRef.size.x * Globals.fieldSizeCoef),
        elementPerRow: Globals.tilesPerRow,
      ),
      levelMenu = LevelMenu(
        Vector2(game.size.x * Globals.levelMenuSizeCoef, 0),
      ),
      BackButton(size: Globals.defaultButtonSize)
        ..position = Vector2(10, Globals.defaultButtonSize.y),
      previousDir = DirectionChangerButton(
        color: GameColors.directionChangeButtonColor,
        tapColor: GameColors.directionChangeTapButtonColor,
        size: Vector2(
          (game.size.x - field.size.x) /
              2 *
              Globals.changeDirectionButtonSizeCoef,
          field.size.y / 3,
        ),
        previous: true,
      ),
      nextDir = DirectionChangerButton(
        color: GameColors.directionChangeButtonColor,
        tapColor: GameColors.directionChangeTapButtonColor,
        size: Vector2(
          (game.size.x - field.size.x) /
              2 *
              Globals.changeDirectionButtonSizeCoef,
          field.size.y / 3,
        ),
        previous: false,
      ),
    ]);
    await super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    field.position = Vector2(size.x / 2, Globals.worldTopOffset);
    levelMenu.position = Vector2(
      size.x / 2,
      Globals.worldTopOffset + field.size.y + Globals.worldLevelMenuOffset,
    );
    previousDir.position = Vector2(
      ((field.position.x - field.size.x / 2)) -
          (game.size.x * (1 - Globals.changeDirectionButtonSizeCoef) / 4),
      field.position.y + field.size.y / 2,
    );
    nextDir.position = Vector2(
      ((field.position.x + field.size.x / 2)) +
          (game.size.x * (1 - Globals.changeDirectionButtonSizeCoef) / 4),
      field.position.y + field.size.y / 2,
    );

    super.onGameResize(size);
  }
}

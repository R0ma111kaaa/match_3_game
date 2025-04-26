import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:match_3_game/src/components/background_component.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart'
    show BackButton;
import 'package:match_3_game/src/components/buttons/direction_changer_button.dart';
import 'package:match_3_game/src/field.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/level_components/scores.dart';
import 'package:match_3_game/src/level_menu.dart';

class GameWorld extends World with HasGameRef<Match3Game> {
  late final Field field;
  late final LevelMenu levelMenu;
  late final DimensionChangerButton previousDir;
  late final DimensionChangerButton nextDir;
  late final DimensionBackground background;
  late final Scores scores;

  bool isMenu = true;
  int? selectedLevel;

  int get getValueIdRange =>
      isMenu
          ? game.currentDimension.valueNumber
          : game.currentDimension.levels[selectedLevel!]["tile_types_num"];

  @override
  Future<void> onLoad() async {
    addAll([
      background = DimensionBackground(),
      field =
          Field(
              size: Vector2.all(game.size.x),
              elementPerRow: Globals.tilesPerRow,
            )
            ..scale = Vector2.all(Globals.fieldMenuSizeCoef)
            ..position = Vector2(game.size.x / 2, Globals.worldTopOffset),
      levelMenu = LevelMenu(
        Vector2(game.size.x * Globals.levelMenuSizeCoef, 0),
      ),
      BackButton(size: Globals.defaultButtonSize)
        ..position = Vector2(10, Globals.defaultButtonSize.y),
      previousDir = DimensionChangerButton(
        size: Vector2(
          (game.size.x - field.size.x * field.scale.x) /
              2 *
              Globals.changeDirectionButtonSizeCoef,
          field.size.y / 3,
        ),
        previous: true,
      ),
      nextDir = DimensionChangerButton(
        size: Vector2(
          (game.size.x - field.size.x * field.scale.x) /
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
    levelMenu.position = Vector2(
      size.x / 2,
      Globals.worldTopOffset + field.size.y + Globals.worldLevelMenuOffset,
    );
    double dirButtonsXOffset = (game.size.x - field.size.x * field.scale.x) / 4;
    double dirButtonsYOffset =
        field.position.y + field.size.y * field.scale.y / 2;
    previousDir.position = Vector2(dirButtonsXOffset, dirButtonsYOffset);
    nextDir.position = Vector2(
      game.size.x - dirButtonsXOffset,
      dirButtonsYOffset,
    );

    super.onGameResize(size);
  }

  Future<void> startLevel(int levelId) async {
    field.unock();
    field.regenerate();
    isMenu = false;
    selectedLevel = levelId;
    field.addAll([
      ScaleEffect.to(
        Vector2.all(Globals.fieldSizeCoef),
        EffectController(duration: Globals.fieldResizeDuration),
      ),
      MoveEffect.to(
        game.size / 2 - Vector2(0, field.size.y / 2),
        EffectController(
          duration: Globals.fieldResizeDuration,
          curve: Globals.defaultCurve,
        ),
      ),
    ]);

    nextDir.lock();
    previousDir.lock();

    nextDir.add(
      MoveEffect.to(
        Vector2(game.size.x + nextDir.size.x / 2, nextDir.position.y),
        EffectController(
          duration: Globals.fieldResizeDuration,
          curve: Globals.defaultCurve,
        ),
        onComplete: nextDir.removeFromParent,
      ),
    );
    previousDir.add(
      MoveEffect.to(
        Vector2(-previousDir.size.x / 2, previousDir.position.y),
        EffectController(
          duration: Globals.fieldResizeDuration,
          curve: Globals.defaultCurve,
        ),
        onComplete: previousDir.removeFromParent,
      ),
    );
    levelMenu.add(
      MoveEffect.to(
        Vector2(levelMenu.position.x, game.size.y),
        EffectController(
          duration: Globals.fieldResizeDuration,
          curve: Globals.defaultCurve,
        ),
        onComplete: levelMenu.removeFromParent,
      ),
    );
    for (final button in levelMenu.levelButtons) {
      button.lock();
    }

    add(
      scores = Scores(
        List<int>.from(game.currentDimension.levels[levelId]["goals"]),
      ),
    );
  }

  Future<void> changeDimension(int delta) async {
    game.changeDimension(delta);
    field.regenerate();
    levelMenu.regenerate();
    background.change();
  }
}

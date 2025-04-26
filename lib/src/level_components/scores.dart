import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/sprite_cache.dart';

class Scores extends PositionComponent
    with HasGameRef<Match3Game>, HasWorldReference<GameWorld> {
  late final int typesCount;

  late final List<Map<String, int>> scoringPoints;
  late final List<Score> scores = [];

  late Vector2 pictureSize;
  late double paddingX;

  // @override
  // bool debugMode = true;

  Scores(List<int> goals)
    : typesCount = goals.length,
      scoringPoints = List.generate(
        goals.length,
        (i) => {"needed": goals[i], "completed": 0},
      );

  @override
  FutureOr<void> onLoad() {
    priority = 0;
    pictureSize = getPictureSize();
    paddingX = Globals.scoresPaddingCoef * pictureSize.x;
    size = Vector2(
      pictureSize.x * typesCount + paddingX * (typesCount + 1),
      pictureSize.y + Globals.scoreTextHeight,
    );
    anchor = Anchor.topCenter;
    position = world.field.position;
    scale = Vector2(0, 0);

    for (int i = 0; i < typesCount; i++) {
      Score score = Score(
        id: i,
        score: scoringPoints[i],
        pictureSize: pictureSize,
      )..position = getScoreLocalPosition(i);
      scores.add(score);
      add(score);
    }
    addAll([
      ScaleEffect.to(
        Vector2(1, 1),
        EffectController(
          duration: Globals.fieldResizeDuration,
          curve: Globals.defaultCurve,
        ),
      ),
      MoveToEffect(
        Vector2(
          game.size.x / 2,
          game.size.y / 2 + (game.size.x * Globals.fieldSizeCoef) / 2,
        ),
        EffectController(
          duration: Globals.fieldResizeDuration,
          curve: Globals.defaultCurve,
        ),
      ),
    ]);

    super.onLoad();
  }

  Vector2 getScoreLocalPosition(int index) {
    Vector2 localPosition = Vector2(
      paddingX + index * (pictureSize.x + paddingX),
      0,
    );
    return localPosition;
  }

  Vector2 getScoreGlobalPosition(int index) {
    Vector2 abs = scores[index].absolutePosition + pictureSize / 2;
    return abs;
  }

  Vector2 getPictureSize() {
    Vector2 size = Vector2.all(
      min(
        game.size.x /
            ((Globals.scoresPaddingCoef + 1) * typesCount +
                Globals.scoresPaddingCoef),
        Globals.maxScorePictureHeight,
      ),
    );
    return size;
  }

  bool isLevelCompleted() {
    bool completed = scoringPoints.every((i) => i["completed"] == i["needed"]);
    return completed;
  }

  bool isMovesOver() {
    return true;
  }
}

class Score extends PositionComponent with HasGameRef<Match3Game> {
  Score({required this.id, required this.score, required this.pictureSize})
    : super(
        size: Vector2(pictureSize.x, pictureSize.y + Globals.scoreTextHeight),
      );

  int id;
  Vector2 pictureSize;
  Map<String, int> score;

  late TextComponent text;

  @override
  Future<void> onLoad() async {
    text = TextComponent(
      textRenderer: TextPaint(style: TextStyle(fontSize: size.x / 3)),
    );
    updateScore(0);

    addAll([
      SpriteComponent(
        sprite: await SpriteCache.getSprite(
          "${game.currentDimension.tileValues[id]}.png",
        ),
        size: pictureSize,
      ),
      text..position = Vector2(0, pictureSize.y),
    ]);
    return super.onLoad();
  }

  Future<void> updateScore(int delta) async {
    score["completed"] = (score["completed"] ?? 0) + delta;
    text.text = "${score["completed"]}/${score["needed"]}";
  }
}

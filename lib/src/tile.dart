// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/mixins/effect_queue.dart';
import 'package:match_3_game/src/tools/sprite_cache.dart';

class Tile extends PositionComponent
    with
        HasWorldReference<GameWorld>,
        HasGameRef<Match3Game>,
        TapCallbacks,
        DragCallbacks,
        EffectQueue {
  int rowIndex;
  int columnindex;

  final int valueId;
  late SpriteComponent picture;

  bool moveable = true;

  Tile({
    required this.rowIndex,
    required this.columnindex,
    required this.valueId,
    required super.size,
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    priority = 10;

    picture = SpriteComponent(
      sprite: await SpriteCache.getSprite(
        "${gameRef.currentDimension.tileValues[valueId]}.png",
      ),
      size: Vector2.all(size.x * Globals.tileIconSizeCoef),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(picture);
  }

  @override
  void onTapDown(TapDownEvent event) {
    world.field.onTileTapped(this);
    super.onTapDown(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    world.field.startDrag(this);
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.canvasEndPosition.x > size.x ||
        event.canvasEndPosition.x < 0 ||
        event.canvasEndPosition.y > size.y ||
        event.canvasEndPosition.y < 0) {
      world.field.updateDrag(event.canvasDelta);
      super.onDragUpdate(event);
    }
  }

  void removeFromGrid() {
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: Globals.tileResizeDuration),
        onComplete: () {
          removeFromParent();
        },
      ),
    );
  }

  // void moveToGoal() {
  //   removeFromParent();
  //   position = absolutePosition;
  //   world.add(this);
  //   addAll([
  //     ScaleEffect.to(
  //       Vector2.all(1 / Globals.fieldSizeCoef),
  //       EffectController(duration: Globals.tileMoveToGoalDuraion),
  //     ),
  //     MoveToEffect(
  //       world.scores.getScoreGlobalPosition(valueId),
  //       EffectController(
  //         duration: Globals.tileMoveToGoalDuraion,
  //         curve: Globals.defaultCurve,
  //       ),
  //       onComplete: () {
  //         removeFromParent();
  //         world.scores.scores[valueId].updateScore(1);
  //       },
  //     ),
  //     SizeEffect.to(
  //       world.scores.pictureSize,
  //       EffectController(
  //         duration: Globals.tileMoveToGoalDuraion,
  //         curve: Globals.defaultCurve,
  //       ),
  //     ),
  //   ]);
  // }
}

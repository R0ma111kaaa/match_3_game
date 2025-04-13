import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/game_world.dart';

class Tile extends PositionComponent with HasWorldReference<GameWorld> {
  int rowIndex;
  int columnindex;
  final int valueId;

  Tile({
    required this.rowIndex,
    required this.columnindex,
    required this.valueId,
    required super.size,
  });

  @override
  // прописать получение анимации при инициализации и в зависимости от текущего
  // уровня анимировать
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    priority = 10;
    add(
      RectangleComponent(
        paint: Paint()..color = world.tileValues[valueId],
        size: Vector2.all(20),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
      ),
    );
    return super.onLoad();
  }

  // не работает как и в филде
  // Future<void> resizeAndMove(
  //   Vector2 newtileSize,
  //   Vector2 newPosition,
  //   double duration,
  // ) async {
  //   size = newtileSize;
  //   addAll([
  //     SizeEffect.to(
  //       newPosition,
  //       EffectController(duration: duration, curve: Curves.linear),
  //     ),
  //     MoveEffect.to(
  //       newPosition,
  //       EffectController(duration: duration, curve: Curves.linear),
  //     ),
  //   ]);
  // }
}

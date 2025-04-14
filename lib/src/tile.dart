import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/game_world.dart';

class Tile extends PositionComponent
    with HasWorldReference<GameWorld>, TapCallbacks, DragCallbacks {
  int rowIndex;
  int columnindex;
  final int valueId;

  bool moveable = true;

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
        size: Vector2.all(size.x * 0.7),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
      ),
    );
    return super.onLoad();
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

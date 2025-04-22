// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/mixins/effect_queue.dart';

class Tile extends PositionComponent
    with
        HasWorldReference<GameWorld>,
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

    await reloadPicture(false);
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

  Future<void> reloadPicture(bool removeOldPicture) async {
    if (removeOldPicture) {
      remove(picture);
    }
    Image image = await Flame.images.load(
      "${world.currentDimension.tileValues[valueId]}.png",
    );
    SpriteComponent newPicture = SpriteComponent(
      sprite: Sprite(image),
      size: Vector2.all(size.x * Globals.tileIconSizeCoef),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    picture = newPicture;
    add(picture);
  }
}

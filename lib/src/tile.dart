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
  late final SpriteComponent picture;

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

    Image image = await Flame.images.load(
      "${world.currentDimension.tileValues[valueId]}.png",
    );
    add(
      picture = SpriteComponent(
        sprite: Sprite(image),
        size: Vector2.all(size.x * Globals.tileIconSizeCoef),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
      ),
    );
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
    picture.add(
      SizeEffect.to(
        Vector2.zero(),
        EffectController(duration: Globals.tileRemoveDuration),
        onComplete: () {
          removeFromParent();
        },
      ),
    );
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

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/algorithms/alailiable_id.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/tile.dart';

class Field extends PositionComponent
    with HasGameRef<Match3Game>, HasWorldReference<GameWorld> {
  int elementPerRow;
  late Vector2 tileSize;

  List<List<Tile?>> tiles;

  late RRect _fieldRrect;
  final Paint _fieldPaint = Paint()..color = GameColors.fieldColor;
  final Paint _borderPaint =
      Paint()
        ..color = GameColors.fieldBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
  final Paint _tileBackgroundPaint =
      Paint()..color = GameColors.tileBackgroundColor;

  Field({required super.size, required this.elementPerRow})
    : tiles = List.generate(
        elementPerRow,
        (_) => List.generate(elementPerRow, (_) => null),
      );

  @override
  Future<void> onLoad() async {
    _fieldRrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      Radius.circular(Globals.tileRadius),
    );
    tileSize = getTileSize(size);
    anchor = Anchor.center;
    fillEmptyField();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_fieldRrect, _borderPaint);
    canvas.drawRRect(_fieldRrect, _fieldPaint);
    for (int row = 0; row < elementPerRow; row++) {
      for (int column = 0; column < elementPerRow; column++) {
        Vector2 tilePosition = getTilePosition(row, column, tileSize, false);
        RRect tileBackgroundRect = RRect.fromLTRBR(
          tilePosition.x + Globals.tilePadding,
          tilePosition.y + Globals.tilePadding,
          tilePosition.x + tileSize.x - Globals.tilePadding,
          tilePosition.y + tileSize.y - Globals.tilePadding,
          Radius.circular(Globals.tileRadius),
        );
        canvas.drawRRect(tileBackgroundRect, _tileBackgroundPaint);
      }
    }
  }

  // ПЕРЕДЕЛАТЬ, НЕ РАБОТАЕТ
  // Future<void> resizeAndMove(
  //   Vector2 newFieldSize,
  //   Vector2 newPosition,
  //   double duration,
  // ) async {
  //   addAll([
  //     SizeEffect.to(
  //       newFieldSize,
  //       EffectController(duration: duration, curve: Curves.linear),
  //     ),
  //     MoveEffect.to(
  //       newPosition,
  //       EffectController(duration: duration, curve: Curves.linear),
  //     ),
  //   ]);
  //   print("first tile size: $tileSize");
  //   spaceBetweenTiles = getSpaceBetweenTiles(newFieldSize);
  //   tileSize = getTileSize(newFieldSize);
  //   print("second tile size: $tileSize");
  //   for (int row = 0; row < tiles.length; row++) {
  //     for (int column = 0; column < tiles[row].length; column++) {
  //       tiles[row][column]?.resizeAndMove(
  //         tileSize,
  //         getTilePosition(row, column, tileSize),
  //         duration,
  //       );
  //     }
  //   }

  //   return;
  // }

  void fillEmptyField() {
    List<List<int?>> valueMatrix = List.generate(
      elementPerRow,
      (rowIndex) => tiles[rowIndex].map((tile) => tile?.valueId).toList(),
    );
    for (int row = 0; row < elementPerRow; row++) {
      for (int column = 0; column < elementPerRow; column++) {
        if (tiles[row][column] == null) {
          int tileValueId = getAvailibleValueId(
            row,
            column,
            valueMatrix,
            world.valuesNumber,
          );
          Vector2 tilePosition = getTilePosition(row, column, tileSize, true);
          Tile tile = Tile(
            size: tileSize,
            rowIndex: row,
            columnindex: column,
            valueId: tileValueId,
          )..position = tilePosition;
          add(tile);
          tiles[row][column] = tile;
        }
      }
    }
  }

  Vector2 getTilePosition(int row, int column, Vector2 tileSize, bool center) {
    double xOffset = center ? tileSize.x / 2 : 0;
    double yOffset = center ? tileSize.y / 2 : 0;
    return Vector2(column * tileSize.x + xOffset, row * tileSize.y + yOffset);
  }

  Vector2 getTileSize(Vector2 newFieldSize) {
    return Vector2(
      (newFieldSize.x) / elementPerRow,
      (newFieldSize.y) / elementPerRow,
    );
  }
}

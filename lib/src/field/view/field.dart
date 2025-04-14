// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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

  Tile? selectedTile;
  Tile? draggedTile;

  late RRect _fieldRrect;
  final Paint _fieldPaint = Paint()..color = GameColors.fieldColor;
  final Paint _borderPaint =
      Paint()
        ..color = GameColors.fieldBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
  final Paint _tileBackgroundPaint =
      Paint()..color = GameColors.tileBackgroundColor;
  final Paint _tileBoxColor = Paint()..color = GameColors.white;

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
        if (row == selectedTile?.rowIndex &&
            column == selectedTile?.columnindex) {
          Rect boxTileRect = Rect.fromLTRB(
            tilePosition.x + Globals.tilePadding + Globals.tileBoxOffsetPadding,
            tilePosition.y + Globals.tilePadding + Globals.tileBoxOffsetPadding,
            tilePosition.x +
                tileSize.x -
                Globals.tilePadding -
                Globals.tileBoxOffsetPadding,
            tilePosition.y +
                tileSize.y -
                Globals.tilePadding -
                Globals.tileBoxOffsetPadding,
          );
          Rect boxTileVerticalRect = Rect.fromLTRB(
            tilePosition.x +
                Globals.tilePadding +
                tileSize.x / Globals.tileBoxInternalDistanseCoef,
            tilePosition.y + Globals.tilePadding,
            tilePosition.x +
                tileSize.x -
                Globals.tilePadding -
                tileSize.x / Globals.tileBoxInternalDistanseCoef,
            tilePosition.y + tileSize.y - Globals.tilePadding,
          );
          Rect boxTileHorizontalRect = Rect.fromLTRB(
            tilePosition.x + Globals.tilePadding,
            tilePosition.y +
                Globals.tilePadding +
                tileSize.y / Globals.tileBoxInternalDistanseCoef,
            tilePosition.x + tileSize.x - Globals.tilePadding,
            tilePosition.y +
                tileSize.y -
                Globals.tilePadding -
                tileSize.y / Globals.tileBoxInternalDistanseCoef,
          );
          canvas.drawRRect(tileBackgroundRect, _tileBoxColor);
          canvas.drawRect(boxTileRect, _tileBackgroundPaint);
          canvas.drawRect(boxTileHorizontalRect, _tileBackgroundPaint);
          canvas.drawRect(boxTileVerticalRect, _tileBackgroundPaint);
        } else {
          canvas.drawRRect(tileBackgroundRect, _tileBackgroundPaint);
        }
      }
    }
  }

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
            game.random,
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

  void onTileTapped(Tile tile) {
    if (selectedTile == null) {
      selectedTile = tile;
    } else {
      if (areNeighbors(selectedTile!, tile)) {
        swapTiles(selectedTile!, tile);
      } else {
        selectedTile = tile;
      }
    }
  }

  bool areNeighbors(Tile a, Tile b) {
    final dx = (a.columnindex - b.columnindex).abs();
    final dy = (a.rowIndex - b.rowIndex).abs();
    return (dx + dy) == 1;
  }

  void swapTiles(Tile firstTile, Tile secondTile) {
    selectedTile = null;

    if (!firstTile.moveable || !secondTile.moveable) return;

    // меняем местами в tiles
    tiles[firstTile.rowIndex][firstTile.columnindex] = secondTile;
    tiles[secondTile.rowIndex][secondTile.columnindex] = firstTile;

    // меняем индексы в тайлах
    int tempRow = firstTile.rowIndex;
    int tempColumn = firstTile.columnindex;

    firstTile.rowIndex = secondTile.rowIndex;
    firstTile.columnindex = secondTile.columnindex;

    secondTile.rowIndex = tempRow;
    secondTile.columnindex = tempColumn;

    // анимируем движение
    final firstTarget = getTilePosition(
      firstTile.rowIndex,
      firstTile.columnindex,
      tileSize,
      true,
    );
    final secondTarget = getTilePosition(
      secondTile.rowIndex,
      secondTile.columnindex,
      tileSize,
      true,
    );
    firstTile.moveable = false;
    firstTile.add(
      MoveToEffect(
        firstTarget,
        EffectController(duration: Globals.tilesSwapDuration),
        onComplete: () => firstTile.moveable = true,
      ),
    );
    secondTile.moveable = false;
    secondTile.add(
      MoveToEffect(
        secondTarget,
        EffectController(duration: Globals.tilesSwapDuration),
        onComplete: () => secondTile.moveable = true,
      ),
    );

    // проверка совпадения
  }

  void startDrag(Tile tile) {
    draggedTile = tile;
  }

  void updateDrag(Vector2 delta) {
    if (draggedTile == null) return;

    final dir = getSwipeDirection(delta);

    final neighbor = getNeighbor(draggedTile!, dir);
    if (neighbor != null) {
      swapTiles(draggedTile!, neighbor);
    }

    draggedTile = null;
  }

  SwipeDirection getSwipeDirection(Vector2 delta) {
    if (delta.x.abs() > delta.y.abs()) {
      return delta.x > 0 ? SwipeDirection.right : SwipeDirection.left;
    } else {
      return delta.y > 0 ? SwipeDirection.down : SwipeDirection.up;
    }
  }

  Tile? getNeighbor(Tile tile, SwipeDirection dir) {
    int row = tile.rowIndex;
    int column = tile.columnindex;

    switch (dir) {
      case SwipeDirection.up:
        row--;
        break;
      case SwipeDirection.down:
        row++;
        break;
      case SwipeDirection.left:
        column--;
        break;
      case SwipeDirection.right:
        column++;
        break;
    }
    if (row < 0 ||
        row >= elementPerRow ||
        column >= elementPerRow ||
        column < 0) {
      return null;
    }
    return tiles[row][column];
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
}

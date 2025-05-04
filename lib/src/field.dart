// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/algorithms/check_combinations.dart';
import 'package:match_3_game/src/algorithms/get_alailiable_id.dart';
import 'package:match_3_game/src/audio_service.dart';
import 'package:match_3_game/src/components/input_blocker.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/tile.dart';

class Field extends PositionComponent
    with HasGameRef<Match3Game>, HasWorldReference<GameWorld> {
  int elementPerRow;
  late Vector2 tileSize;

  List<List<Tile?>> tileMatrix;
  late ClipComponent drawableField;

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

  final InputBlocker blocker;

  bool isLose = false;
  bool isWin = false;

  Field({required super.size, required this.elementPerRow})
    : tileMatrix = List.generate(
        elementPerRow,
        (_) => List.generate(elementPerRow, (_) => null),
      ),
      blocker = InputBlocker(size: size);

  @override
  Future<void> onLoad() async {
    lock();
    priority = 20;
    drawableField = ClipComponent.rectangle(size: size);
    add(drawableField);

    _fieldRrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      Radius.circular(Globals.tileRadius),
    );
    tileSize = getTileSize(size);
    anchor = Anchor.topCenter;
    fillEmptyField(
      List.generate(tileMatrix[0].length, (_) => tileMatrix.length),
    );
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

  Future<void> regenerate() async {
    combinations.clear();
    clear();
    fillEmptyField(
      List.generate(tileMatrix[0].length, (_) => tileMatrix.length),
    );
  }

  bool isAnimating = false;
  List<List<Tile>> combinations = [];
  Future<void> makeTurn(Tile firstTile, Tile secondTile) async {
    if (isAnimating || !firstTile.moveable || !secondTile.moveable) return;
    swapTiles(firstTile, secondTile);

    combinations = getCombinations(tileMatrix);

    if (combinations.isEmpty) {
      swapTiles(firstTile, secondTile);
    } else {
      isLose = world.turnsCounter.increment();
      List<int> dropIndexes = [];
      isAnimating = true;
      while (combinations.isNotEmpty) {
        List<Tile> tilesFromCombinations =
            (Set<Tile>.from(combinations.expand((el) => el))).toList();
        makeTilesUnmoveable(tilesFromCombinations);
        await Future.delayed(
          Duration(milliseconds: Globals.waitDurationMiliseconds),
        );
        if (combinations.isNotEmpty) {
          removeTilesAndAddPoints(tilesFromCombinations, true);
          dropIndexes = await dropTiles();
          fillEmptyField(dropIndexes);
          combinations = getCombinations(tileMatrix);
        }
      }
      if (isLose && !isWin) {
        game.router.pushNamed("lose");
        return;
      } else if (isWin) {
        return;
      }
      await Future.delayed(
        Duration(
          milliseconds:
              (dropIndexes.isNotEmpty
                      ? dropIndexes.reduce((a, b) => a > b ? a : b) *
                          Globals.tileDropDuration *
                          1000
                      : 0)
                  .toInt(),
        ),
      );
      isAnimating = false;
    }
  }

  void swapTiles(Tile firstTile, Tile secondTile) {
    selectedTile = null;

    AudioService().playWhoosh();

    // меняем местами в tiles
    tileMatrix[firstTile.rowIndex][firstTile.columnindex] = secondTile;
    tileMatrix[secondTile.rowIndex][secondTile.columnindex] = firstTile;

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
    firstTile.addQueueEffect(
      MoveToEffect(
        firstTarget,
        EffectController(duration: Globals.tilesSwapDuration),
      ),
    );
    secondTile.addQueueEffect(
      MoveToEffect(
        secondTarget,
        EffectController(duration: Globals.tilesSwapDuration),
      ),
    );
  }

  Future<void> fillEmptyField(List<int> dropIndexes) async {
    List<List<int?>> valueMatrix = getValueMatrix();
    for (int row = 0; row < elementPerRow; row++) {
      for (int column = 0; column < elementPerRow; column++) {
        if (tileMatrix[row][column] == null) {
          int tileValueId = getAvailibleValueId(
            row,
            column,
            valueMatrix,
            world.getValueIdRange,
            game.random,
          );
          valueMatrix[row][column] = tileValueId;
          Vector2 tilePosition = getTilePosition(
            row - dropIndexes[column],
            column,
            tileSize,
            true,
          );
          Tile tile = Tile(
            size: tileSize,
            rowIndex: row,
            columnindex: column,
            valueId: tileValueId,
          )..position = tilePosition;
          dropTile(tile, dropIndexes[column]);
          drawableField.add(tile);
          tileMatrix[row][column] = tile;
        }
      }
    }
  }

  List<List<int?>> getValueMatrix() {
    List<List<int?>> valueMatrix = List.generate(
      elementPerRow,
      (rowIndex) => tileMatrix[rowIndex].map((tile) => tile?.valueId).toList(),
    );
    return valueMatrix;
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
        makeTurn(selectedTile!, tile);
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

  void startDrag(Tile tile) {
    draggedTile = tile;
  }

  void updateDrag(Vector2 delta) {
    if (draggedTile == null) return;

    final dir = getSwipeDirection(delta);

    final neighbor = getNeighbor(draggedTile!, dir);
    if (neighbor != null) {
      makeTurn(draggedTile!, neighbor);
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
    return tileMatrix[row][column];
  }

  Future<void> removeTilesAndAddPoints(
    List<Tile?> tilesToRemove,
    bool addPoints,
  ) async {
    if (!world.isMenu) {
      AudioService().playDrop();
    }
    for (Tile? tile in tilesToRemove) {
      if (tile == null) continue;
      int id = tile.valueId;
      if (addPoints &&
          id < world.scores.scoringPoints.length &&
          (world.scores.scoringPoints[id]["needed"]! >
              world.scores.scoringPoints[id]["completed"]!)) {
        world.scores.scores[tile.valueId].updateScore(1);
        if (world.scores.isLevelCompleted()) {
          lock();
          await Future.delayed(
            Duration(milliseconds: Globals.waitDurationMiliseconds * 3),
          );
          game.router.pushNamed("win");
          isWin = true;
        }
      }
      tile.removeFromGrid();
      tileMatrix[tile.rowIndex][tile.columnindex] = null;
    }
  }

  Future<List<int>> dropTiles() async {
    List<int> dropIndexes = List.generate(tileMatrix[0].length, (_) => 0);
    for (int rowIndex = tileMatrix.length - 1; rowIndex >= 0; rowIndex--) {
      for (
        int columnIndex = 0;
        columnIndex < tileMatrix[0].length;
        columnIndex++
      ) {
        Tile? tile = tileMatrix[rowIndex][columnIndex];
        if (tile == null) {
          dropIndexes[columnIndex]++;
        } else {
          tileMatrix[tile.rowIndex][tile.columnindex] = null;
          int deltaPosition = dropIndexes[columnIndex];
          tile.rowIndex += deltaPosition;
          tileMatrix[tile.rowIndex][tile.columnindex] = tile;
          dropTile(tile, deltaPosition);
        }
      }
    }
    return dropIndexes;
  }

  void dropTile(Tile? tile, int deltaPosition) {
    if (tile == null) return;
    if (deltaPosition <= 0) {
      return;
    }
    tile.moveable = false;
    tile.addQueueEffect(
      MoveToEffect(
        getTilePosition(tile.rowIndex, tile.columnindex, tileSize, true),
        EffectController(
          duration: deltaPosition * Globals.tileDropDuration,
          curve: Curves.easeInOut,
          startDelay:
              Globals.minDelay *
              ((elementPerRow - tile.columnindex) +
                  (elementPerRow - tile.rowIndex)),
        ),
        onComplete: () => tile.moveable = true,
      ),
    );
  }

  void makeTilesUnmoveable(List<Tile> tilesToRemove) {
    for (Tile tile in tilesToRemove) {
      tile.moveable = false;
    }
  }

  void lock() {
    add(blocker);
  }

  void unock() {
    blocker.removeFromParent();
  }

  void clear() {
    List<Tile?> tilesToRemove = tileMatrix.expand((list) => list).toList();
    removeTilesAndAddPoints(tilesToRemove, false);
  }
}

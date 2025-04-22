// ignore_for_file: avoid_print

import 'package:match_3_game/src/tile.dart';

List<List<Tile>> getCombinations(List<List<Tile?>> tileMatrix) {
  List<List<Tile>> combinations = [];
  for (int i = 0; i < tileMatrix.length; i++) {
    combinations += getRowCombinations(i, tileMatrix);
  }
  for (int j = 0; j < tileMatrix[0].length; j++) {
    combinations += getColumnCombinations(j, tileMatrix);
  }
  // if (combinations.isNotEmpty)
  //   print(
  //     combinations.map(
  //       (list) => list.map((el) => "(${el.rowIndex}, ${el.columnindex})"),
  //     ),
  //   );
  // return [];
  return combinations;
}

List<List<Tile>> getPairSwapCombinations(
  List<List<Tile?>> tileMatrix,
  Tile firstTile,
  Tile secondTile,
) {
  Set rowIndexes = {firstTile.rowIndex, secondTile.rowIndex};
  Set columnIndexes = {firstTile.columnindex, secondTile.columnindex};

  List<List<Tile>> combinations = [];

  for (int i in rowIndexes) {
    combinations += getRowCombinations(i, tileMatrix);
  }
  for (int j in columnIndexes) {
    combinations += getColumnCombinations(j, tileMatrix);
  }
  // if (combinations.isNotEmpty)
  //   print(
  //     combinations.map(
  //       (list) => list.map((el) => "(${el.rowIndex}, ${el.columnindex})"),
  //     ),
  //   );
  // return [];
  return combinations;
}

List<List<Tile>> getRowCombinations(
  int rowIndex,
  List<List<Tile?>> tileMatrix,
) {
  List<List<Tile>> rowCombinations = [];
  List<Tile> currentCombination = [];
  for (int columnIndex = 0; columnIndex < tileMatrix[0].length; columnIndex++) {
    Tile? currentTile = tileMatrix[rowIndex][columnIndex];
    if (currentTile != null &&
        (currentCombination.isEmpty ||
            currentTile.valueId == currentCombination.last.valueId)) {
      currentCombination.add(currentTile);
    } else {
      if (currentCombination.length >= 3) {
        rowCombinations.add(List.from(currentCombination));
      }
      currentCombination.clear();
      if (currentTile != null) {
        currentCombination.add(currentTile);
      }
    }
  }
  if (currentCombination.length >= 3) {
    rowCombinations.add(List.from(currentCombination));
  }
  return rowCombinations;
}

List<List<Tile>> getColumnCombinations(
  int columnIndex,
  List<List<Tile?>> tileMatrix,
) {
  List<List<Tile>> columnCombinations = [];
  List<Tile> currentCombination = [];
  for (int rowIndex = 0; rowIndex < tileMatrix.length; rowIndex++) {
    Tile? currentTile = tileMatrix[rowIndex][columnIndex];
    if ((currentTile != null) &&
        (currentCombination.isEmpty ||
            currentTile.valueId == currentCombination.last.valueId)) {
      currentCombination.add(currentTile);
    } else {
      if (currentCombination.length >= 3) {
        columnCombinations.add(List.from(currentCombination));
      }
      currentCombination.clear();
      if (currentTile != null) {
        currentCombination.add(currentTile);
      }
    }
  }
  if (currentCombination.length >= 3) {
    columnCombinations.add(List.from(currentCombination));
  }
  return columnCombinations;
}

import 'dart:math';

int getAvailibleValueId(
  int row,
  int column,
  List<List<int?>> valueMatrix,
  int range,
  Random random,
) {
  List<int> availableIds = List.generate(range, (i) => i);

  // код, который удаляет невозможные тайлы из списка
  for ((int, int) deltaCords in [(-2, -1), (-1, 1), (1, 2)]) {
    int firstColumn = column + deltaCords.$1;
    int secondColumn = column + deltaCords.$2;
    int firstRow = row + deltaCords.$1;
    int secondRow = row + deltaCords.$2;
    if (firstColumn >= 0 && secondColumn < valueMatrix[0].length) {
      int? currentValueId = valueMatrix[row][firstColumn];
      if (currentValueId == valueMatrix[row][secondColumn]) {
        availableIds.remove(currentValueId);
      }
    }
    if (firstRow >= 0 && secondRow < valueMatrix.length) {
      int? currentValueId = valueMatrix[firstRow][column];
      if (currentValueId == valueMatrix[secondRow][column]) {
        availableIds.remove(currentValueId);
      }
    }
  }

  int valueId = availableIds[random.nextInt(availableIds.length)];
  return valueId;
}

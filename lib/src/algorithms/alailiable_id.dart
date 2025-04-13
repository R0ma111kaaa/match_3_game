import 'dart:math';

int getAvailibleValueId(
  int row,
  int column,
  List<List<int?>> valueMatrix,
  int range,
  Random random,
) {
  int valueId = random.nextInt(range);
  valueMatrix[row][column] = valueId;
  return valueId;
}

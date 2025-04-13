int getAvailibleValueId(
  int row,
  int column,
  List<List<int?>> valueMatrix,
  int range,
) {
  int valueId = 1;
  valueMatrix[row][column] = valueId;
  return valueId;
}

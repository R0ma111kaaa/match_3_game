int getAvailibleValueId(
  int row,
  int column,
  List<List<int?>> valueMatrix,
  int range,
) {
  int valueId = 0;
  valueMatrix[row][column] = valueId;
  return valueId;
}

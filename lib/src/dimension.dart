import 'dart:convert';

import 'package:flutter/services.dart';

class Dimension {
  int id;
  late final Map<String, dynamic> data;

  late final String title;
  late final List<Map<String, dynamic>> levels;
  late final List<String> tileValues;
  late final int valueNumber;
  late final String backgroundFilename;
  late final List<Color> colors;

  Dimension._(this.id);

  static Future<Dimension> create(int id) async {
    final direction = Dimension._(id);
    await direction._load();
    return direction;
  }

  Future<void> _load() async {
    String jsonString = await rootBundle.loadString(
      'assets/dimensions/$id.json',
    );
    data = jsonDecode(jsonString);

    title = data["title"];
    levels = List<Map<String, dynamic>>.from(data["levels"]);
    tileValues = List<String>.from(data["tiles"]);
    valueNumber = tileValues.length;
    backgroundFilename = data["background_image_filename"];

    List<String> colorStrings = List<String>.from(data["colors"]);
    colors = List<Color>.generate(
      colorStrings.length,
      (i) => Color(int.parse(colorStrings[i].replaceFirst('#', ''), radix: 16)),
    );
  }
}

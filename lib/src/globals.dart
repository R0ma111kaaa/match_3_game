import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Globals {
  static final double buttonIconSizeCoef = 0.7;

  static final double menuXOffset = 50;
  static final double menuHeight = 200;
  static final double menuButtonsOffset = 15;
  static final double menuButtonsHeight = (menuHeight - menuButtonsOffset) / 2;

  static final double tileRadius = 5;
  static final double fieldOffset = 10;
  static final double tilePadding = 1;

  static final double tileBoxOffsetPadding = 3;
  static final double tileBoxInternalDistanseCoef = 4;

  static final double fieldResizeDuration = 3;
  static final double tilesSwapDuration = 0.2;

  static final Vector2 defaultButtonSize = Vector2.all(50);
}

class GameColors {
  static final Color grey = Colors.grey;
  static final Color black = Colors.black;
  static final Color red = Colors.red;
  static final Color green = Colors.green;
  static final Color white = Colors.white;

  static final Color fieldColor = const Color.fromARGB(255, 12, 32, 47);
  static final Color tileBackgroundColor = const Color.fromRGBO(19, 53, 78, 1);
  static final Color fieldBorderColor = const Color.fromRGBO(119, 210, 254, 1);
}

class Fonts {}

enum SwipeDirection { left, right, up, down }

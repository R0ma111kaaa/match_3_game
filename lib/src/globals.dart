import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Globals {
  static final int levelsPerRow = 4;
  static final int tilesPerRow = 8;

  static final int dimensionsCount = 2;

  static final double buttonIconSizeCoef = 0.7;

  static final double menuXOffset = 50;
  static final double menuHeight = 200;
  static final double menuButtonsOffset = 15;
  static final double menuButtonsHeight = (menuHeight - menuButtonsOffset) / 2;

  static final double tileRadius = 5;
  static final double tilePadding = 1;

  static final double tileBoxOffsetPadding = 3;
  static final double tileBoxInternalDistanseCoef = 4;

  static final double changeDirectionButtonSizeCoef = 0.7;

  static final double levelButtonOffset = 10;

  static final double tileIconSizeCoef = 0.9;

  static final double fieldMenuSizeCoef = 0.7;
  static final double fieldSizeCoef = 0.9;
  static final double levelMenuSizeCoef = 0.9;

  static final double worldTopOffset = 150;
  static final double worldLevelMenuOffset = 0;

  static final double fieldResizeDuration = 0.7;
  static final double tilesSwapDuration = 0.2;
  static final double tileResizeDuration = 0.2;
  static final double tileDropDuration = 0.1;
  static final double tileMoveToGoalDuraion = 2;
  static final double backgroundLoadDuration = 1;
  static final double stringsResizeDuration = 0.5;
  static final int waitDurationMiliseconds = 500;

  static final double minDelay = 0.02;

  static final Vector2 defaultButtonSize = Vector2.all(50);

  static Curve defaultCurve = Curves.easeInOut;

  static double scoreTextHeight = 50;
  static double maxScorePictureHeight = 50;
  static double scoresPaddingCoef = 0.2;
}

class GameColors {
  static final Color grey = Colors.grey;
  static final Color black = Colors.black;
  static final Color red = Colors.red;
  static final Color green = Colors.green;
  static final Color white = Colors.white;

  static final Color transparentBackground = Color.fromARGB(150, 0, 0, 0);

  static final Color fieldColor = const Color.fromARGB(255, 12, 32, 47);
  static final Color tileBackgroundColor = const Color.fromRGBO(19, 53, 78, 1);
  static final Color fieldBorderColor = const Color.fromRGBO(119, 210, 254, 1);

  static final Color directionChangeButtonColor = const Color.fromRGBO(
    119,
    210,
    254,
    1,
  );
  static final Color directionChangeTapButtonColor = const Color.fromARGB(
    255,
    13,
    97,
    139,
  );

  static final Color completedLevelColor = const Color.fromARGB(
    255,
    49,
    52,
    53,
  );
  static final Color uncompletedLevelColor = const Color.fromARGB(
    255,
    161,
    171,
    176,
  );
}

class Fonts {}

enum SwipeDirection { left, right, up, down }

import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:match_3_game/src/components/background_component.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart'
    show BackButton;
import 'package:match_3_game/src/field.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class GameWorld extends World with HasGameRef<Match3Game> {
  late final Field field;

  // есть несолько измерений (изменение не равно мир)
  // в каждом измерении свои уровни, цвета, картинки и т.д.
  // при переходе в другое измерение параметры примведенные ниже меняются
  List<Color> tileValues = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.blue,
  ];
  late int valuesNumber;
  // пока что захардкожено, потом нужно добавить в Globals
  // для каждого изерения разные параметры

  @override
  FutureOr<void> onLoad() {
    valuesNumber = tileValues.length;
    addAll([
      HomePageBackground(),
      field = Field(
        size: Vector2.all(gameRef.size.x - Globals.fieldOffset * 2),
        elementPerRow: 5,
      ),
      BackButton(size: Globals.defaultButtonSize)
        ..position = Globals.defaultButtonSize,
    ]);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    field.position = Vector2(size.x / 2, size.y / 2);
    super.onGameResize(size);
  }
}

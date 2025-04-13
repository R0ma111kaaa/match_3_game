import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:match_3_game/src/components/background_component.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart'
    show BackButton;
import 'package:match_3_game/src/field/view/field.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class GameWorld extends World with HasGameRef<Match3Game> {
  late final Field field;

  // есть несолько измерений (изменение не равно мир)
  // в каждом измерении свои уровни, цвета, картинки и т.д.
  // при переходе в другое измерение параметры примведенные ниже меняются
  List<RectangleComponent> tileValues = [
    RectangleComponent(
      paint: Paint()..color = Colors.blueAccent,
      size: Vector2.all(20),
    ),
    RectangleComponent(
      paint: Paint()..color = Colors.red,
      size: Vector2.all(20),
    ),
    RectangleComponent(
      paint: Paint()..color = Colors.teal,
      size: Vector2.all(20),
    ),
    RectangleComponent(
      paint: Paint()..color = Colors.purple,
      size: Vector2.all(20),
    ),
    RectangleComponent(
      paint: Paint()..color = Colors.pink,
      size: Vector2.all(20),
    ),
  ];
  int valuesNumber = 5;
  // пока что захардкожено, потом нужно добавить в Globals
  // для каждого изерения разные параметры

  @override
  FutureOr<void> onLoad() {
    addAll([
      HomePageBackground(),
      field = Field(
        size: Vector2.all(gameRef.size.x - Globals.fieldOffset * 2),
        elementPerRow: 10,
      ),
      BackButton(size: Vector2.all(100)),
    ]);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    field.position = Vector2(size.x / 2, size.y / 2);
    super.onGameResize(size);
  }
}

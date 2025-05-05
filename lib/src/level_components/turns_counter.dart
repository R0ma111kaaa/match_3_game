import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class TurnsCounter extends TextComponent with HasGameRef<Match3Game> {
  int counter = 0;
  late int goal;

  TurnsCounter(this.goal)
    : super(text: "${Globals.turnCounterText}$goal", anchor: Anchor.topCenter);

  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: game.size.x / 10,
        fontWeight: FontWeight.bold,
        fontFamily: "RuneScape",
      ),
    );
    super.onLoad();
  }

  bool increment() {
    counter++;
    text = "${Globals.turnCounterText}${goal - counter}";
    return counter >= goal;
  }
}

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class EndScreenPage extends PositionComponent
    with HasGameRef<Match3Game>, TapCallbacks, DragCallbacks {
  String text;

  EndScreenPage({required this.text});

  @override
  Future<void> onLoad() async {
    size = game.size;
    add(
      RectangleComponent(
        paint: Paint()..color = GameColors.transparentBackground,
        size: size,
      ),
    );
    add(
      TextComponent(
        text: text,
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: TextPaint(style: TextStyle(fontSize: size.x / 10)),
      )..add(
        SequenceEffect([
          ScaleEffect.to(
            Vector2(1.2, 1.2),
            EffectController(duration: Globals.stringsResizeDuration),
          ),
          ScaleEffect.to(
            Vector2(1, 1),
            EffectController(duration: Globals.stringsResizeDuration),
          ),
        ], infinite: true),
      ),
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.router.popUntilNamed("home");
    event.handled = true;
    super.onTapDown(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    event.handled = true;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    event.handled = true;
  }
}

class WinPage extends EndScreenPage {
  WinPage() : super(text: "Уровень пройден");
}

class LosePage extends EndScreenPage {
  LosePage() : super(text: "Ты проиграл чувачек");
}

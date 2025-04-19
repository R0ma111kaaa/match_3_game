import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:match_3_game/src/globals.dart';

class SimpleButton extends PositionComponent with TapCallbacks {
  SimpleButton({
    required this.color,
    required this.tapColor,
    required Vector2 size,
    super.anchor = Anchor.topLeft,
  }) : super(size: size);

  final Color color;
  final Color tapColor;
  late final RRect _rrect;
  late final Paint _paint;
  late void Function() action;

  @override
  Future<void> onLoad() async {
    _paint = Paint()..color = color;
    _rrect = RRect.fromLTRBR(0, 0, size.x, size.y, Radius.circular(size.y / 3));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _paint);
    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _paint.color = tapColor;
  }

  @override
  void onTapUp(TapUpEvent event) {
    _paint.color = color;
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _paint.color = color;
  }
}

class IconButton extends SimpleButton {
  IconButton({
    required super.color,
    required super.tapColor,
    required super.size,
  });
  late final Image image;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      SpriteComponent(
        sprite: Sprite(image),
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2),
        size: Vector2(
          size.x * Globals.buttonIconSizeCoef,
          size.y * Globals.buttonIconSizeCoef,
        ),
      ),
    );
  }
}

class TextButton extends SimpleButton {
  TextButton({
    required this.textString,
    required super.color,
    required super.tapColor,
    required super.size,
    this.fontSize = 50,
  });
  final String textString;
  late final TextComponent text;
  final double fontSize;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    text = TextComponent(
      text: textString,
      textRenderer: TextPaint(
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(text);
  }
}

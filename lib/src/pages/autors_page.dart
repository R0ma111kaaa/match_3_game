import 'dart:async';

import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/back_button.dart';
import 'package:match_3_game/src/game.dart';

class AutorsPage extends Component with HasGameRef<Match3Game> {
  @override
  Future<void> onLoad() async {
    Vector2 screenSize = game.size;
    add(
      BackButton(size: Vector2.all(50))
        ..position = Vector2(screenSize.x / 2, screenSize.y / 2)
        ..anchor = Anchor.center,
    );
    return super.onLoad();
  }
}

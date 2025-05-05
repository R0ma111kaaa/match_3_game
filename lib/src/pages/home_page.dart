import 'dart:async';

import 'package:flame/components.dart';
import 'package:match_3_game/src/components/background_component.dart';
import 'package:match_3_game/src/components/buttons/autors_button.dart';
import 'package:match_3_game/src/components/buttons/settings_button.dart';
import 'package:match_3_game/src/components/buttons/start_button_component.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart' hide GameColors;

class HomePage extends Component with HasGameRef<Match3Game> {
  @override
  Future<void> onLoad() async {
    return super.onLoad();
  }

  @override
  void onMount() {
    Vector2 menuSize = Vector2(
      gameRef.size.x - Globals.menuXOffset * 2,
      Globals.menuHeight,
    );
    Vector2 menuPosition = Vector2(
      Globals.menuXOffset,
      (gameRef.size.y - menuSize.y) / 2,
    );
    addAll([DimensionBackground(), Menu(menuPosition, menuSize)]);
    super.onMount();
  }
}

class Menu extends PositionComponent with HasGameRef<Match3Game> {
  SettingsButton? _settingsButton;
  StartButton? _startButton;
  AutorsButton? _autorsButton;

  Menu(Vector2 position, Vector2 size) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _startButton = StartButton(
      size: Vector2(size.x, Globals.menuButtonsHeight),
    );
    _settingsButton = SettingsButton(
      size: Vector2.all(Globals.menuButtonsHeight),
    );

    _autorsButton = AutorsButton(
      size: Vector2(
        size.x - Globals.menuButtonsHeight - Globals.menuButtonsOffset,
        Globals.menuButtonsHeight,
      ),
    );

    addAll([_settingsButton!, _startButton!, _autorsButton!]);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _startButton?.position = _startButton!.size / 2;
    _settingsButton?.position =
        _settingsButton!.size / 2 +
        Vector2(0, Globals.menuButtonsHeight + Globals.menuButtonsOffset);
    _autorsButton?.position =
        _autorsButton!.size / 2 +
        Vector2(
          Globals.menuButtonsHeight + Globals.menuButtonsOffset,
          Globals.menuButtonsHeight + Globals.menuButtonsOffset,
        );
  }
}

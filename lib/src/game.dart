import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/pages/autors_page.dart';
import 'package:match_3_game/src/pages/home_page.dart';
import 'package:match_3_game/src/pages/settings_page.dart';

class Match3Game extends FlameGame {
  late final RouterComponent router;

  Random random = Random();

  // @override
  // bool debugMode = true;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    addAll([
      router = RouterComponent(
        routes: {
          "home": Route(HomePage.new),
          "settings": Route(SettingsPage.new),
          "autors": Route(AutorsPage.new),
          "world": WorldRoute(GameWorld.new),
        },
        initialRoute: "home",
      ),
    ]);
  }
}

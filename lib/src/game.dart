import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:match_3_game/src/dimension.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';
import 'package:match_3_game/src/pages/autors_page.dart';
import 'package:match_3_game/src/pages/end_screens.dart';
import 'package:match_3_game/src/pages/home_page.dart';
import 'package:match_3_game/src/pages/settings_page.dart';

class Match3Game extends FlameGame {
  late final RouterComponent router;

  Random random = Random();

  late final List<Dimension> dimensions;
  late Dimension currentDimension;

  // @override
  // bool debugMode = true;

  @override
  Future<void> onLoad() async {
    List<Future<Dimension>> futures = List.generate(
      Globals.dimensionsCount,
      (i) => Dimension.create(i),
    );
    dimensions = await Future.wait(futures);
    currentDimension = dimensions[0];

    camera.viewfinder.anchor = Anchor.topLeft;
    addAll([
      router = RouterComponent(
        routes: {
          "home": Route(HomePage.new, maintainState: false),
          "settings": Route(SettingsPage.new),
          "autors": Route(AutorsPage.new),
          "world": WorldRoute(GameWorld.new, maintainState: false),
          "win": Route(WinPage.new),
          "lose": Route(LosePage.new),
        },
        initialRoute: "home",
      ),
    ]);
  }

  void changeDimension(int delta) {
    int currentIndex = dimensions.indexOf(currentDimension);
    int newIndex = (currentIndex + delta) % dimensions.length;
    if (newIndex < 0) {
      newIndex += dimensions.length;
    }
    currentDimension = dimensions[newIndex];
  }
}

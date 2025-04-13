import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:match_3_game/src/game.dart';

class HomePageBackground extends Component with HasGameRef<Match3Game> {
  // фон первой страницы - совокупность движущихся декораций
  // и статичной картинки в зависимотсти от текущего выбранного мира
  @override
  Future<void> onLoad() async {
    priority = -1;
    Image staticBackgroundImage = await Flame.images.load(
      'home_page_background.jpg',
    );
    add(
      SpriteComponent(
        sprite: Sprite(staticBackgroundImage),
        size: gameRef.size,
      ),
    );
  }
}

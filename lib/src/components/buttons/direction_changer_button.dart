import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game_world.dart';

class DirectionChangerButton extends SimpleButton
    with HasWorldReference<GameWorld> {
  DirectionChangerButton({
    required super.color,
    required super.tapColor,
    required super.size,
    required this.previous,
  });

  bool previous;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    action =
        previous
            ? () {
              world.changeDirection(-1);
            }
            : () {
              world.changeDirection(1);
            };
  }
}

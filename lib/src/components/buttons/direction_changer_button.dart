import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game_world.dart';
import 'package:match_3_game/src/globals.dart';

class DimensionChangerButton extends SimpleButton
    with HasWorldReference<GameWorld> {
  DimensionChangerButton({required super.size, required this.previous})
    : super(
        color: GameColors.directionChangeButtonColor,
        tapColor: GameColors.directionChangeTapButtonColor,
      );

  bool previous;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    action =
        previous
            ? () {
              world.changeDimension(-1);
            }
            : () {
              world.changeDimension(1);
            };
  }
}

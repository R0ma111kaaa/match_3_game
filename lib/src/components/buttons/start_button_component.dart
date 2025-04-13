import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class StartButton extends TextButton with HasGameRef<Match3Game> {
  StartButton({required super.size})
    : super(
        textString: "Старт",
        color: GameColors.green,
        tapColor: GameColors.red,
      );

  @override
  Future<void> onLoad() {
    action = () => gameRef.router.pushNamed("world");
    return super.onLoad();
  }
}

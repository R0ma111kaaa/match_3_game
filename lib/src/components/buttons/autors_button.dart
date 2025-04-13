import 'package:flame/components.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class AutorsButton extends TextButton with HasGameRef<Match3Game> {
  AutorsButton({required super.size})
    : super(
        textString: "Авторы",
        color: GameColors.green,
        tapColor: GameColors.red,
      );

  @override
  Future<void> onLoad() {
    action = () => gameRef.router.pushNamed("autors");
    return super.onLoad();
  }
}

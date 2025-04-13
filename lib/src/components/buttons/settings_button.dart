import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:match_3_game/src/components/buttons/default_buttons.dart';
import 'package:match_3_game/src/game.dart';
import 'package:match_3_game/src/globals.dart';

class SettingsButton extends IconButton with HasGameRef<Match3Game> {
  SettingsButton({required super.size})
    : super(color: GameColors.white, tapColor: GameColors.red);

  @override
  Future<void> onLoad() async {
    action = () => gameRef.router.pushNamed("settings");
    image = await Flame.images.load("settings.png");
    return super.onLoad();
  }
}

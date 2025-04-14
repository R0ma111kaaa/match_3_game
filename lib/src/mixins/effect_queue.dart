import 'package:flame/components.dart';
import 'package:flame/effects.dart';

mixin EffectQueue on Component {
  final List<Effect> _effectQueue = [];
  bool _isAnimating = false;

  void addQueueEffect(Effect effect) {
    _effectQueue.add(effect);
    _tryNextEffect();
  }

  void _tryNextEffect() {
    if (_isAnimating || _effectQueue.isEmpty) return;

    _isAnimating = true;
    final effect = _effectQueue.removeAt(0);

    (this as Component).add(
      effect
        ..onComplete = () {
          _isAnimating = false;
          _tryNextEffect();
        },
    );
  }

  void clearQueue() {
    _effectQueue.clear();
  }

  bool get isAnimating => _isAnimating;
}

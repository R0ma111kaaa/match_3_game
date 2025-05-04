import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class SpriteCache {
  static final Map<String, Sprite> _cache = {};

  static Future<Sprite> getSprite(String name) async {
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    }
    Image image = await Flame.images.load(name);
    Sprite sprite = Sprite(image);
    _cache[name] = sprite;
    return sprite;
  }
}

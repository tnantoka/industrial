import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../main_game.dart';

class Slashing extends PositionComponent with HasGameRef<MainGame> {
  Slashing({
    super.position,
  });

  late final SpriteAnimationComponent _sprite;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final spriteSheet = SpriteSheet(
      image: game.image,
      srcSize: Vector2(32, 16),
    );

    _sprite = SpriteAnimationComponent(
      position: Vector2(64, -32),
      size: Vector2.all(64),
      anchor: Anchor.center,
      animation: spriteSheet.createAnimation(
        row: 18,
        from: 2,
        to: 6,
        stepTime: 0.1,
      ),
    );
    await add(_sprite);
  }
}

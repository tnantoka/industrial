import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main_game.dart';

enum FireDirection {
  top,
  bottom,
  left,
  right,
}

class Fire extends PositionComponent with HasGameRef<MainGame> {
  Fire({
    super.position,
    required this.direction,
  });

  final _random = Random();

  late final List<SpriteComponent> _sprites = [];
  final speed = 300.0;

  var elapsed = 0.0;
  FireDirection direction;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    for (var i = 0; i < 10; i++) {
      final sprite = SpriteComponent(
        position: Vector2(0, 0),
        size: Vector2.all(3 * (i + 1)),
        anchor: Anchor.center,
        sprite: game.spriteSheet.getSprite(16, 13),
      );
      await add(sprite);
      _sprites.add(sprite);
    }

    await _sprites.last.add(
      CircleHitbox(
        radius: 8,
        position: Vector2.all(_sprites.last.size.x * 0.5 - 8),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    elapsed += dt;

    if (elapsed > 0.04) {
      elapsed = 0.0;

      for (var i = 0; i < _sprites.length - 1; i++) {
        final sprite1 = _sprites[i];
        final sprite2 = _sprites[i + 1];
        sprite1.position = sprite2.position;

        sprite1.position += Vector2(
          (_random.nextDouble() * 200 - 100) * dt,
          (_random.nextDouble() * 200 - 100) * dt,
        );
      }
    }

    var vx = 0.0;
    var vy = 0.0;
    switch (direction) {
      case FireDirection.top:
        vy = -speed;
        break;
      case FireDirection.bottom:
        vy = speed;
        break;
      case FireDirection.left:
        vx = -speed;
        break;
      case FireDirection.right:
        vx = speed;
        break;
    }

    _sprites.last.position += Vector2(vx, vy) * dt;
  }
}

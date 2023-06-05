import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../main_game.dart';
import './fire.dart';

enum ReflectorDirection {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class Reflector extends PositionComponent
    with HasGameRef<MainGame>, CollisionCallbacks, TapCallbacks {
  Reflector({
    super.position,
    super.size,
    this.direction = ReflectorDirection.topLeft,
  }) : super(
          anchor: Anchor.center,
        );

  late final SpriteComponent _sprite;
  late final Sprite _normalSprite;
  late final Sprite _activeSprite;

  ReflectorDirection direction;
  var isHit = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _normalSprite = game.spriteSheet.getSprite(10, 21);
    _activeSprite = game.spriteSheet.getSprite(10, 22);

    _sprite = SpriteComponent(
      position: Vector2(0, 0),
      size: size,
      sprite: _normalSprite,
    );
    await add(_sprite);

    final hitboxLength = size.x * 0.25;
    await add(
      RectangleHitbox(
        size: Vector2.all(hitboxLength),
        position: Vector2.all(size.x * 0.5 - hitboxLength * 0.5),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (direction) {
      case ReflectorDirection.topLeft:
        if (!isFlippedHorizontally) {
          flipHorizontally();
        }
        if (isFlippedVertically) {
          flipVertically();
        }
        break;
      case ReflectorDirection.topRight:
        if (isFlippedHorizontally) {
          flipHorizontally();
        }
        if (isFlippedVertically) {
          flipVertically();
        }
        break;
      case ReflectorDirection.bottomLeft:
        if (!isFlippedHorizontally) {
          flipHorizontally();
        }
        if (!isFlippedVertically) {
          flipVertically();
        }
        break;
      case ReflectorDirection.bottomRight:
        if (isFlippedHorizontally) {
          flipHorizontally();
        }
        if (!isFlippedVertically) {
          flipVertically();
        }
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (isHit) {
      return;
    }

    final parent = other.parent;
    if (other.parent is Fire) {
      isHit = true;

      final fire = parent as Fire;
      switch (direction) {
        case ReflectorDirection.topLeft:
          switch (fire.direction) {
            case FireDirection.top:
              fire.removeFromParent();
              break;
            case FireDirection.bottom:
              fire.direction = FireDirection.left;
              break;
            case FireDirection.left:
              fire.removeFromParent();
              break;
            case FireDirection.right:
              fire.direction = FireDirection.top;
              break;
          }
          break;
        case ReflectorDirection.topRight:
          switch (fire.direction) {
            case FireDirection.top:
              fire.removeFromParent();
              break;
            case FireDirection.bottom:
              fire.direction = FireDirection.right;
              break;
            case FireDirection.left:
              fire.direction = FireDirection.top;
              break;
            case FireDirection.right:
              fire.removeFromParent();
              break;
          }
          break;
        case ReflectorDirection.bottomLeft:
          switch (fire.direction) {
            case FireDirection.top:
              fire.direction = FireDirection.left;
              break;
            case FireDirection.bottom:
              fire.removeFromParent();
              break;
            case FireDirection.left:
              fire.removeFromParent();
              break;
            case FireDirection.right:
              fire.direction = FireDirection.bottom;
              break;
          }
          break;
        case ReflectorDirection.bottomRight:
          switch (fire.direction) {
            case FireDirection.top:
              fire.direction = FireDirection.right;
              break;
            case FireDirection.bottom:
              fire.removeFromParent();
              break;
            case FireDirection.left:
              fire.direction = FireDirection.bottom;
              break;
            case FireDirection.right:
              fire.removeFromParent();
              break;
          }
          break;
      }

      _sprite.sprite = _activeSprite;
      Future.delayed(
        const Duration(milliseconds: 100),
        () => {
          _sprite.sprite = _normalSprite,
          isHit = false,
        },
      );
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    switch (direction) {
      case ReflectorDirection.topLeft:
        direction = ReflectorDirection.topRight;
        break;
      case ReflectorDirection.topRight:
        direction = ReflectorDirection.bottomRight;
        break;
      case ReflectorDirection.bottomRight:
        direction = ReflectorDirection.bottomLeft;
        break;
      case ReflectorDirection.bottomLeft:
        direction = ReflectorDirection.topLeft;
        break;
    }
  }
}

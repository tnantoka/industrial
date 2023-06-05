import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';

class MainGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, HasTappablesBridge {
  late Player _player;

  late ui.Image image;
  late SpriteSheet spriteSheet;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // debugMode = true;
    await add(
      RectangleComponent(
        position: Vector2(size.x * 0.5, 0),
        size: Vector2(1, size.y),
      ),
    );
    await add(
      RectangleComponent(
        position: Vector2(0, size.y * 0.5),
        size: Vector2(size.x, 1),
      ),
    );

    image = await images.load('industrial.v2.png');
    spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2.all(16),
    );

    _player = Player(
      position: Vector2(size.x * 0.5, size.y * 0.5),
    );
    await add(_player);

    await add(
      Reflector(
        position: Vector2(size.x * 0.9, size.y * 0.5 - 32),
        size: Vector2.all(64),
      ),
    );
    await add(
      Reflector(
        position: Vector2(size.x * 0.1, size.y * 0.5 - 32),
        direction: ReflectorDirection.topRight,
        size: Vector2.all(64),
      ),
    );
    await add(
      Reflector(
        position: Vector2(size.x * 0.1, size.y * 0.1 - 32),
        direction: ReflectorDirection.bottomRight,
        size: Vector2.all(64),
      ),
    );
    await add(
      Reflector(
        position: Vector2(size.x * 0.9, size.y * 0.1 - 32),
        direction: ReflectorDirection.bottomLeft,
        size: Vector2.all(64),
      ),
    );
    await add(
      Reflector(
        position: Vector2(size.x * 0.1, size.y * 0.9 - 32),
        direction: ReflectorDirection.topRight,
        size: Vector2.all(64),
      ),
    );
    await add(
      Reflector(
        position: Vector2(size.x * 0.9, size.y * 0.9 - 32),
        direction: ReflectorDirection.topLeft,
        size: Vector2.all(64),
      ),
    );
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    var isHandled = false;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _player.moveLeft();
      isHandled = true;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _player.moveRight();
      isHandled = true;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _player.jump();
      isHandled = true;
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      _player.attack();
      isHandled = true;
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      add(
        Fire(
          position: _player.position +
              Vector2(
                _player.isFlippedHorizontally ? -80 : 80,
                -32,
              ),
          direction: _player.isFlippedHorizontally
              ? FireDirection.left
              : FireDirection.right,
        ),
      );
    }

    if (!isHandled) {
      _player.idle();
    }

    return isHandled ? KeyEventResult.handled : KeyEventResult.ignored;
  }
}

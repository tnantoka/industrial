import 'dart:async';

import 'package:flame/components.dart';

import '../main_game.dart';
import './slashing.dart';

enum PlayerState {
  idle,
  walk,
  attack,
  jump,
  landing,
}

class Player extends PositionComponent with HasGameRef<MainGame> {
  Player({
    super.position,
    this.state = PlayerState.idle,
  }) {
    _groundY = position.y;
  }

  PlayerState state;

  final speed = 200.0;
  final gravity = 500.0;
  final jumpPower = 200.0;

  late final double _groundY;
  late final SpriteAnimationComponent _sprite;

  var vx = 0.0;
  var vy = 0.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _sprite = SpriteAnimationComponent(
      position: Vector2(0, -32),
      size: Vector2.all(64),
      anchor: Anchor.center,
    );
    await add(_sprite);

    _updateAnimation();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += Vector2(vx, vy) * dt;

    if (vy != 0) {
      vy += gravity * dt;
      if (position.y >= _groundY) {
        vy = 0;
        position.y = _groundY;
        _updateState(PlayerState.landing);
        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            if (vx != 0) {
              _updateState(PlayerState.walk);
            } else {
              _updateState(PlayerState.idle);
            }
          },
        );
      }
    }
  }

  void idle() {
    vx = 0;
    if (state != PlayerState.jump &&
        state != PlayerState.landing &&
        state != PlayerState.attack) {
      _updateState(PlayerState.idle);
    }
  }

  void moveLeft() {
    _move(-speed);
    if (!isFlippedHorizontally) {
      flipHorizontally();
    }
  }

  void moveRight() {
    _move(speed);
    if (isFlippedHorizontally) {
      flipHorizontally();
    }
  }

  void jump() {
    if (vy != 0 || state == PlayerState.landing) {
      return;
    }

    vy = -jumpPower;
    _updateState(PlayerState.jump);
  }

  void attack() {
    if (state == PlayerState.attack || state == PlayerState.landing) {
      return;
    }

    final slashing = Slashing(position: Vector2.zero());
    add(slashing);

    _updateState(PlayerState.attack);
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (vy != 0) {
          _updateState(PlayerState.jump);
        } else if (vx != 0) {
          _updateState(PlayerState.walk);
        } else {
          _updateState(PlayerState.idle);
        }
        slashing.removeFromParent();
      },
    );
  }

  void _move(double vx) {
    this.vx = vx;
    if (state == PlayerState.idle) {
      _updateState(PlayerState.walk);
    }
  }

  void _updateState(PlayerState nextState) {
    if (state == nextState) {
      return;
    }

    state = nextState;
    _updateAnimation();
  }

  void _updateAnimation() async {
    _sprite.animation = game.spriteSheet.createAnimation(
      row: _row(),
      from: _from(),
      to: _to(),
      stepTime: _stepTime(),
    );
  }

  int _row() {
    switch (state) {
      case PlayerState.idle:
        return 16;
      case PlayerState.walk:
        return 17;
      case PlayerState.attack:
        return 19;
      case PlayerState.jump:
        return 17;
      case PlayerState.landing:
        return 16;
    }
  }

  int _from() {
    switch (state) {
      case PlayerState.idle:
        return 0;
      case PlayerState.walk:
        return 0;
      case PlayerState.attack:
        return 0;
      case PlayerState.jump:
        return 0;
      case PlayerState.landing:
        return 5;
    }
  }

  int _to() {
    switch (state) {
      case PlayerState.idle:
        return 4;
      case PlayerState.walk:
        return 8;
      case PlayerState.attack:
        return 4;
      case PlayerState.jump:
        return 8;
      case PlayerState.landing:
        return 8;
    }
  }

  double _stepTime() {
    switch (state) {
      case PlayerState.idle:
        return 0.2;
      case PlayerState.walk:
        return 0.1;
      case PlayerState.attack:
        return 0.1;
      case PlayerState.jump:
        return 0.3;
      case PlayerState.landing:
        return 0.1;
    }
  }
}

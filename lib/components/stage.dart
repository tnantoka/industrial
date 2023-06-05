import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import 'reflector.dart';

class Stage extends PositionComponent {
  Stage({
    super.position,
    super.size,
  });

  final _random = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    const num = 10;
    final length = size.x / num;
    for (var i = 0; i <= num; i++) {
      await add(
        RectangleComponent(
          position: Vector2(length * i, 0),
          size: Vector2(1, size.y),
        ),
      );
      await add(
        RectangleComponent(
          position: Vector2(0, length * i),
          size: Vector2(size.x, 1),
        ),
      );
    }

    var x = 0;
    var y = 4;
    var used = [];
    var reflectors = [];

    while (true) {
      if (!used.contains(Point(x, y))) {
        final reflector = Reflector(
          position:
              Vector2(x * length + length * 0.5, y * length + length * 0.5),
          size: Vector2.all(length),
        );
        await add(reflector);
        reflectors.add(reflector);
        used.add(Point(x, y));
      }

      if (_random.nextInt(2) == 0) {
        x += 1;
      } else if (_random.nextInt(2) == 0) {
        y += 1;
      } else {
        y -= 1;
      }

      if (x < 0 || y < 0 || x >= num || y >= num) {
        final rect = RectangleComponent(
          paint: BasicPalette.red.paint(),
          position: reflectors.last.position,
          size: reflectors.last.size,
          anchor: reflectors.last.anchor,
        );
        await add(rect);

        reflectors.last.removeFromParent();
        reflectors.removeLast();
        break;
      }
    }
  }
}

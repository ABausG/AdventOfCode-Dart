import '../utils/index.dart';
import 'day04.dart';

enum Direction {
  up,
  right,
  down,
  left;

  Direction turn() {
    switch (this) {
      case up:
        return right;
      case right:
        return down;
      case down:
        return left;
      case left:
        return up;
    }
  }

  (int, int) move((int, int) position) {
    final (x, y) = position;

    switch (this) {
      case up:
        return (x, y - 1);
      case right:
        return (x + 1, y);
      case down:
        return (x, y + 1);
      case left:
        return (x - 1, y);
    }
  }
}

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<String> parseInput() {
    return input.getPerLine().whereNot((line) => line.isEmpty).toList();
  }

  @override
  int solvePart1() {
    final input = parseInput();

    const guardSymbol = '^';
    const wallSymbol = '#';
    final initialY = input.indexWhere((line) => line.contains(guardSymbol));
    final initialX = input[initialY].indexOf(guardSymbol);

    (int, int) position = (initialX, initialY);
    Direction direction = Direction.up;
    final visited = <(int, int)>{};

    String? currentLetter = letterAt(position, input);
    while (currentLetter != null) {
      visited.add(position);
      final newPosition = direction.move(position);
      final nextLetter = letterAt(newPosition, input);
      if (nextLetter == wallSymbol) {
        direction = direction.turn();
      }
      position = direction.move(position);
      currentLetter = letterAt(position, input);
    }

    return visited.length;
  }

  Set<(int, int)>? _visitedCells(
    (int, int) initialPosition,
    Direction initialDirection,
    List<String> input,
  ) {
    (int, int) position = initialPosition;
    Direction direction = initialDirection;
    final visited = <((int, int), Direction)>{};

    String? currentLetter = letterAt(position, input);
    bool looping = false;
    while (currentLetter != null && !looping) {
      visited.add((position, direction));
      final newPosition = direction.move(position);
      final nextLetter = letterAt(newPosition, input);
      bool didTurn = false;

      if (nextLetter == '#') {
        direction = direction.turn();
        didTurn = true;
      }
      if (didTurn && visited.contains((position, direction))) {
        looping = true;
      }
      position = direction.move(position);
      currentLetter = letterAt(position, input);
    }

    return !looping ? visited.map((e) => e.$1).toSet() : null;
  }

  @override
  int solvePart2() {
    final input = parseInput();

    const guardSymbol = '^';
    const wallSymbol = '#';
    final initialY = input.indexWhere((line) => line.contains(guardSymbol));
    final initialX = input[initialY].indexOf(guardSymbol);

    final loopingPositions = <(int, int)>{};

    final rawVisits = _visitedCells((initialX, initialY), Direction.up, input);

    for (final dummyObjectPosition in rawVisits!) {
      if (letterAt(dummyObjectPosition, input) == guardSymbol) {
        continue;
      }

      (int, int) position = (initialX, initialY);
      Direction direction = Direction.up;
      final visited = <((int, int), Direction)>{};

      bool hitsWall() {
        final newPosition = direction.move(position);
        final nextLetter = letterAt(newPosition, input);
        return nextLetter == wallSymbol || newPosition == dummyObjectPosition;
      }

      String? currentLetter = letterAt(position, input);
      while (currentLetter != null) {
        visited.add((position, direction));

        bool hittingWall = hitsWall();
        while (hittingWall) {
          direction = direction.turn();
          hittingWall = hitsWall();
        }

        position = direction.move(position);
        currentLetter = letterAt(position, input);

        if (visited.contains((position, direction))) {
          loopingPositions.add(dummyObjectPosition);
          break;
        }
      }
    }

    // 1995 - too low
    // 1997 - too low
    // Not 2024
    // Not 3990
    // Did this really clear? 2064
    // Not 2033
    // Maybe 2008 - Using hitsWall() function
    return loopingPositions.length;
  }
}

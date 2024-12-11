import 'dart:math';

import '../utils/index.dart';
import 'index.dart';

num? numberAt((int, int) coordinates, List<List<num>> input) {
  final (x, y) = coordinates;

  if (y < 0 || y >= input.length) {
    return null;
  }

  final row = input[y];

  if (x < 0 || x >= row.length) {
    return null;
  }

  return row[x];
}

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  List<List<int>> parseInput() {
    return input
        .getPerLine()
        .where((test) => test.isNotEmpty)
        .map((line) => line.split('').map(int.parse).toList())
        .toList();
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final allDirections = List<List<Direction>>.generate(
      pow(Direction.values.length, 9).toInt(),
      (index) => List<Direction>.generate(
        9,
        (i) => Direction.values[(index ~/ pow(Direction.values.length, i)) %
            Direction.values.length],
      ),
    );

    final trailheads = <(int, int)>[];

    for (final (y, row) in input.indexed) {
      for (final (x, number) in row.indexed) {
        if (number == 0) {
          trailheads.add((x, y));
        }
      }
    }

    final results = trailheads.map((trailhead) {
      final validPeaks = <(int, int)>[];
      for (final directionOrder in allDirections) {
        int currentNumber = 0;
        (int, int) currentCoordinates = trailhead;

        for (final direction in directionOrder) {
          final nextCoordinates = direction.move(currentCoordinates);
          final nextNumber = numberAt(nextCoordinates, input);

          if (nextNumber == null) {
            break;
          }

          if (nextNumber != currentNumber + 1) {
            break;
          }

          if (nextNumber == 9) {
            validPeaks.add(nextCoordinates);
            break;
          }

          currentNumber = nextNumber.toInt();
          currentCoordinates = nextCoordinates;
        }
      }
      return validPeaks.toSet().length;
    });

    print(results);
    return results.fold(0, (previous, element) => previous + element);
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final allDirections = List<List<Direction>>.generate(
      pow(Direction.values.length, 9).toInt(),
      (index) => List<Direction>.generate(
        9,
        (i) => Direction.values[(index ~/ pow(Direction.values.length, i)) %
            Direction.values.length],
      ),
    );

    final trailheads = <(int, int)>[];

    for (final (y, row) in input.indexed) {
      for (final (x, number) in row.indexed) {
        if (number == 0) {
          trailheads.add((x, y));
        }
      }
    }

    final results = trailheads.map((trailhead) {
      final validPeaks = <(int, int)>[];
      for (final directionOrder in allDirections) {
        int currentNumber = 0;
        (int, int) currentCoordinates = trailhead;

        for (final direction in directionOrder) {
          final nextCoordinates = direction.move(currentCoordinates);
          final nextNumber = numberAt(nextCoordinates, input);

          if (nextNumber == null) {
            break;
          }

          if (nextNumber != currentNumber + 1) {
            break;
          }

          if (nextNumber == 9) {
            validPeaks.add(nextCoordinates);
            break;
          }

          currentNumber = nextNumber.toInt();
          currentCoordinates = nextCoordinates;
        }
      }
      return validPeaks.length;
    });

    return results.fold(0, (previous, element) => previous + element);
  }
}

import '../utils/index.dart';

enum CheckDirection {
  east((1, 0)),
  southEast((1, 1)),
  south((0, 1)),
  southWest((-1, 1)),
  west((-1, 0)),
  northWest((-1, -1)),
  north((0, -1)),
  northEast((1, -1));

  const CheckDirection(this.factors);
  final (int, int) factors;
}

String? letterAt((int, int) coordinates, List<String> input) {
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

bool checkWord(
  List<String> input,
  String word,
  (int, int) coordinates,
  CheckDirection direction,
) {
  final (x, y) = coordinates;
  for (int charIndex = 0; charIndex < word.length; charIndex++) {
    final char = word[charIndex];
    final (xFactor, yFactor) = direction.factors;
    final offset = charIndex;

    final checkLocation = (x + xFactor * offset, y + yFactor * offset);

    final letter = letterAt(checkLocation, input);
    if (letter != char) {
      return false;
    }
  }
  return true;
}

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final input = parseInput();
    const word = 'XMAS';

    int count = 0;
    for (int row = 0; row < input.length; row++) {
      for (int col = 0; col < input[row].length; col++) {
        for (final direction in CheckDirection.values) {
          if (checkWord(input, word, (col, row), direction)) {
            count++;
          }
        }
      }
    }

    return count;
  }

  @override
  int solvePart2() {
    final input = parseInput();
    const word = 'MAS';

    List<CheckDirection> checkDirection(CheckDirection direction) =>
        switch (direction) {
          CheckDirection.east => [CheckDirection.north, CheckDirection.south],
          CheckDirection.southEast => [
              CheckDirection.northEast,
              CheckDirection.southWest,
            ],
          CheckDirection.south => [CheckDirection.west, CheckDirection.east],
          CheckDirection.southWest => [
              CheckDirection.northWest,
              CheckDirection.southEast,
            ],
          CheckDirection.west => [CheckDirection.north, CheckDirection.south],
          CheckDirection.northWest => [
              CheckDirection.southWest,
              CheckDirection.northEast,
            ],
          CheckDirection.north => [CheckDirection.west, CheckDirection.east],
          CheckDirection.northEast => [
              CheckDirection.southEast,
              CheckDirection.northWest,
            ],
        };

    int validEntries = 0;

    final List<(((int, int), CheckDirection), ((int, int), CheckDirection))>
        pairs = [];

    for (int row = 0; row < input.length; row++) {
      for (int col = 0; col < input[row].length; col++) {
        for (final direction in CheckDirection.values.where((direction) {
          final (x, y) = direction.factors;
          return x != 0 && y != 0;
        })) {
          final isMas = checkWord(input, word, (col, row), direction);

          if (isMas) {
            final checkDirections = checkDirection(direction);
            final (xDirection, yDirection) = direction.factors;
            for (final checkDirection in checkDirections) {
              final (xCheckDirection, yCheckDirection) = checkDirection.factors;
              final checkCoordinates = (
                col + xDirection - xCheckDirection,
                row + yDirection - yCheckDirection
              );
              if (pairs.contains(
                (
                  (checkCoordinates, checkDirection),
                  ((col, row), direction),
                ),
              )) {
                continue;
              }

              final hasCrossWord =
                  checkWord(input, word, checkCoordinates, checkDirection);
              if (hasCrossWord) {
                pairs.add(
                  (
                    ((col, row), direction),
                    (checkCoordinates, checkDirection),
                  ),
                );
                validEntries++;
              }
            }
          }
        }
      }
    }

    return validEntries;
  }
}

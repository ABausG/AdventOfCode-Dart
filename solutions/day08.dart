import '../utils/index.dart';
import 'index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  List<String> parseInput() {
    return input.getPerLine().where((test) => test.isNotEmpty).toList();
  }

  Map<String, List<(int, int)>> get antennas {
    final map = <String, List<(int, int)>>{};

    final regex = RegExp('([A-z0-9])');
    final input = parseInput();
    for (int y = 0; y < input.length; y++) {
      for (var x = 0; x < input[y].length; x++) {
        final coordinates = (x, y);
        final symbol = letterAt(coordinates, input);

        if (symbol != null && regex.hasMatch(symbol)) {
          if (!map.containsKey(symbol)) {
            map[symbol] = [coordinates];
          } else {
            map[symbol]!.add(coordinates);
          }
        }
      }
    }

    return map;
  }

  @override
  int solvePart1() {
    final allAntennas = antennas;

    final yBound = parseInput().length;
    final xBound = parseInput().first.length;

    final antinodes = <(int, int)>{};
    for (final entry in allAntennas.entries) {
      final coordinates = entry.value;

      for (final (index, location) in coordinates.indexed) {
        final (x, y) = location;

        for (final (matchingX, matchingY) in coordinates.sublist(index + 1)) {
          final (dX, dY) = (matchingX - x, matchingY - y);

          final antinodeBase = (x - dX, y - dY);
          final antinodeMatch = (matchingX + dX, matchingY + dY);

          antinodes.addAll([antinodeBase, antinodeMatch]);
        }
      }
    }

    antinodes.removeWhere((antinode) {
      final (x, y) = antinode;
      return x < 0 || x >= xBound || y < 0 || y >= yBound;
    });

    return antinodes.length;
  }

  @override
  int solvePart2() {
    final allAntennas = antennas;

    final yBound = parseInput().length;
    final xBound = parseInput().first.length;

    final antinodes = <(int, int)>{};
    for (final entry in allAntennas.entries) {
      final coordinates = entry.value;

      for (final (index, location) in coordinates.indexed) {
        final (x, y) = location;

        for (final (matchingX, matchingY) in coordinates.sublist(index + 1)) {
          final (dX, dY) = (matchingX - x, matchingY - y);

          // Go to top left
          (int, int) antinode = (matchingX - dX, matchingY - dY);
          while (antinode.$1 >= 0 && antinode.$2 >= 0) {
            antinodes.add(antinode);
            antinode = (antinode.$1 - dX, antinode.$2 - dY);
          }

          // Go to bottom right
          antinode = (x + dX, y + dY);
          while (antinode.$1 < xBound && antinode.$2 < yBound) {
            antinodes.add(antinode);
            antinode = (antinode.$1 + dX, antinode.$2 + dY);
          }
        }
      }
    }

    antinodes.removeWhere((antinode) {
      final (x, y) = antinode;
      return x < 0 || x >= xBound || y < 0 || y >= yBound;
    });

    // 1114 too low
    // 1123 too high
    return antinodes.length;
  }
}

import '../utils/index.dart';
import 'index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  List<String> parseInput() {
    return input.getPerLine().where((test) => test.isNotEmpty).toList();
  }

  Set<(int, int)> calcNeighborMembers(
    (int, int) position,
    String groupValue,
    List<String> input,
  ) {
    final neighbors = <(int, int)>{};
    const checkDirections = Direction.values;
    for (final direction in checkDirections) {
      final checkPosition = direction.move(position);
      final letter = letterAt(checkPosition, input);
      if (letter == groupValue) {
        neighbors.add(checkPosition);
      }
    }
    return neighbors;
  }

  List<Set<(int, int)>> calculateGroups() {
    final groups = <Set<(int, int)>>[];

    final input = parseInput();

    for (int y = 0; y < input.length; y++) {
      final line = input[y];

      for (int x = 0; x < line.length; x++) {
        if (groups.any((group) => group.contains((x, y)))) {
          continue;
        }

        final groupSymbol = letterAt((x, y), input);
        if (groupSymbol == null) {
          continue;
        }
        final group = {(x, y)};
        int checkIndex = 0;

        while (checkIndex < group.length) {
          final checkPosition = group.elementAt(checkIndex);
          final neighbors =
              calcNeighborMembers(checkPosition, groupSymbol, input);
          group.addAll(neighbors);
          checkIndex++;
        }
        groups.add(group);
      }
    }
    return groups;
  }

  @override
  Future<int> solvePart1() async {
    final groups = calculateGroups();

    final fences = await Future.wait([
      for (final group in groups)
        Future(() async {
          int fenceCount = 0;
          for (final coordinate in group) {
            for (final direction in Direction.values) {
              final checkPosition = direction.move(coordinate);
              if (!group.contains(checkPosition)) {
                fenceCount++;
              }
            }
          }
          return fenceCount;
        }),
    ]);

    int price = 0;

    for (int i = 0; i < groups.length; i++) {
      price += groups[i].length * fences[i];
    }

    return price;
  }

  @override
  Future<int> solvePart2() async {
    final input = parseInput();
    final groups = calculateGroups();

    final List<List<((int, int), Direction)>> fences = [];

    await Future.wait([
      for (final group in groups)
        Future(() async {
          final List<((int, int), Direction)> sides = [];
          for (final coordinate in group) {
            for (final direction in Direction.values) {
              final checkPosition = direction.move(coordinate);
              if (!group.contains(checkPosition)) {
                sides.add((coordinate, direction));
              }
            }
          }

          fences.add(sides);
        }),
    ]);

    final List<List<List<((int, int), Direction)>>> neededSides =
        fences.mapIndexed((index, fenceSide) {
      final sides = <List<((int, int), Direction)>>[];
      for (final fence in fenceSide) {
        if (sides.any((side) => side.contains(fence))) {
          continue;
        }
        final ((x, y), direction) = fence;
        final attachedSides = [fence];

        if (direction == Direction.up || direction == Direction.down) {
          // Go Left
          for (int xIndex = x - 1; xIndex >= 0; xIndex--) {
            final checkPosition = (xIndex, y);
            if (fenceSide.any((test) => test == (checkPosition, direction))) {
              attachedSides.add((checkPosition, direction));
            } else {
              // All Fences found to the left
              break;
            }
          }

          // Go Right
          for (int xIndex = x + 1; xIndex <= input[y].length; xIndex++) {
            final checkPosition = (xIndex, y);
            if (fenceSide.any((test) => test == (checkPosition, direction))) {
              attachedSides.add((checkPosition, direction));
            } else {
              // All Fences found to the right
              break;
            }
          }
        } else {
          // Go Up
          for (int yIndex = y - 1; yIndex >= 0; yIndex--) {
            final checkPosition = (x, yIndex);
            if (fenceSide.any((test) => test == (checkPosition, direction))) {
              attachedSides.add((checkPosition, direction));
            } else {
              // All Fences found to the top
              break;
            }
          }
          // Go Down
          for (int yIndex = y + 1; yIndex <= input.length; yIndex++) {
            final checkPosition = (x, yIndex);
            if (fenceSide.any((test) => test == (checkPosition, direction))) {
              attachedSides.add((checkPosition, direction));
            } else {
              // All Fences found to the bottom
              break;
            }
          }
        }

        sides.add(attachedSides);
      }
      return sides;
    }).toList();

    int price = 0;

    for (int i = 0; i < groups.length; i++) {
      final areaSize = groups.elementAt(i).length;
      final fenceCount = neededSides.elementAt(i).length;
      price += areaSize * fenceCount;
    }

    return price;
  }
}

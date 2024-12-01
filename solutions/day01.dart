import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  (List<int>, List<int>) parseInput() {
    final leftList = <int>[];
    final rightList = <int>[];

    final lines = input.getPerLine();

    for (final line in lines) {
      final ids = line.split(RegExp(r'(\s)+'));
      if (ids.length == 2) {
        leftList.add(int.parse(ids[0]));
        rightList.add(int.parse(ids[1]));
      }
    }

    return (leftList, rightList);
  }

  @override
  int solvePart1() {
    final (leftList, rightList) = parseInput();

    // Sort the lists
    leftList.sort();
    rightList.sort();

    final distances = <int>[];
    for (int i = 0; i < leftList.length; i++) {
      final leftEntry = leftList[i];
      final rightEntry = rightList[i];

      final distance = leftEntry - rightEntry;

      distances.add(distance.abs());
    }

    final distanceSum = distances.reduce((value, element) => value + element);
    return distanceSum;
  }

  @override
  int solvePart2() {
    final (leftList, rightList) = parseInput();

    int similarity = 0;

    final rightListCounts = <int, int>{};

    for (final number in rightList) {
      rightListCounts[number] = (rightListCounts[number] ?? 0) + 1;
    }

    for (final number in leftList) {
      similarity += number * (rightListCounts[number] ?? 0);
    }

    return similarity;
  }
}

import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<int> parseInput() {
    final numbers = input.getPerWhitespace().first.split(RegExp(r'\s'));
    return numbers.map(int.tryParse).nonNulls.toList();
  }

  int solve(int blinks) {
    Map<int, int> counts = {};
    final input = parseInput();

    for (final number in input) {
      counts[number] = (counts[number] ?? 0) + 1;
    }

    for (int i = 0; i < blinks; i++) {
      final newCounts = <int, int>{};

      void add(int number, int count) {
        newCounts[number] = (newCounts[number] ?? 0) + count;
      }

      for (final entry in counts.entries) {
        final number = entry.key;
        final count = entry.value;

        if (number == 0) {
          add(1, count);
        } else if (number.toString().length.isEven) {
          final half = number.toString().length ~/ 2;
          final firstHalf = int.parse(number.toString().substring(0, half));
          final secondHalf = int.parse(number.toString().substring(half));

          add(firstHalf, count);
          add(secondHalf, count);
        } else {
          add(number * 2024, count);
        }
      }

      counts = newCounts;
    }

    return counts.values.fold(0, (combined, count) => combined + count);
  }

  @override
  int solvePart1() {
    return solve(25);
  }

  @override
  int solvePart2() {
    return solve(75);
  }
}

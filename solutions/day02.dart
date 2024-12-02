import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput();

    final safeLines = lines.where((line) {
      if (line.isEmpty) return false;

      final chars = line.split(RegExp(r'(\s)+'));
      final numbers = chars.map(int.parse).toList();
      return checkLine(numbers, recheck: false);
    });

    return safeLines.length;
  }

  bool checkLine(List<int> numbers, {required bool recheck}) {
    bool? isIncreasing;

    for (final (index, number) in numbers.sublist(1).indexed) {
      final previousNumber = numbers[index];

      final recheckWithoutFirst = List<int>.from(numbers).sublist(1);
      final recheckWithoutThis = List<int>.from(numbers)..removeAt(index + 1);
      final recheckWithoutPrevious = List<int>.from(numbers)
        ..removeAt(index + 0);
      if (number == previousNumber) {
        if (recheck) {
          return checkLine(recheckWithoutFirst, recheck: false) ||
              checkLine(recheckWithoutThis, recheck: false) ||
              checkLine(recheckWithoutPrevious, recheck: false);
        }
        return false;
      } else {
        isIncreasing ??= number > previousNumber;
      }

      final difference = number - previousNumber;

      final isSafe = ((isIncreasing && difference > 0) ||
              (!isIncreasing && difference < 0)) &&
          difference.abs() >= 1 &&
          difference.abs() <= 3;
      if (!isSafe) {
        if (recheck) {
          return checkLine(recheckWithoutFirst, recheck: false) ||
              checkLine(recheckWithoutThis, recheck: false) ||
              checkLine(recheckWithoutPrevious, recheck: false);
        }
        return false;
      }
    }
    return true;
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    final safeLines = lines.where((line) {
      if (line.isEmpty) return false;

      final chars = line.split(RegExp(r'(\s)+'));
      final numbers = chars.map(int.parse).toList();
      return checkLine(numbers, recheck: true);
    });

    return safeLines.length;
  }
}

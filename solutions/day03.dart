import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  String parseInput() {
    return input.asString;
  }

// Previous: 698 - 1536811
  @override
  int solvePart1() {
    int result = 0;
    final pattern = RegExp(r'mul\(([\d]{1,3}),([\d]{1,3})\)');

    final line = parseInput();

    final matches = pattern.allMatches(line).toList();

    for (final match in matches) {
      final groups = match.groups([1, 2]);
      final a = int.parse(groups[0]!);
      final b = int.parse(groups[1]!);
      result += a * b;
    }

    return result;
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final mulPattern = RegExp(r'mul\(([\d]{1,3}),([\d]{1,3})\)');
    final doPattern = RegExp(r'do\(\)');
    final dontPattern = RegExp(r"don't\(\)");
    final dos = doPattern.allMatches(input);
    final donts = dontPattern.allMatches(input).toList();
    final multis = mulPattern.allMatches(input).toList();

    int result = 0;

    bool inDoBlock = true;

    for (int i = 0; i < input.length; i++) {
      final doBlock = dos.firstWhereOrNull((doBlock) => doBlock.start == i);
      final dontBlock = donts.firstWhereOrNull(
        (dontBlock) => dontBlock.start == i,
      );
      final mulBlock = multis.firstWhereOrNull(
        (mulBlock) => mulBlock.start == i,
      );

      if (doBlock != null) {
        print('Switch to DO');
        inDoBlock = true;
      } else if (dontBlock != null) {
        print('Switch to DONT');
        inDoBlock = false;
      } else if (inDoBlock && mulBlock != null) {
        final groups = mulBlock.groups([1, 2]);
        final a = int.parse(groups[0]!);
        final b = int.parse(groups[1]!);
        result += a * b;
      }
    }

    /* // Failed Tries
    assert(result < 168191679); // - Too high

    assert(result > 76882378); // - Too low
    assert(result > 77794501); // - Too low
    // 169103802 - Too high not submitted
    assert(result != 78047809); */
    return result;
  }
}

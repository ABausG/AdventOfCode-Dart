import 'dart:math';

import '../utils/index.dart';

enum Operator {
  plus,
  multiply,
  concatenate,
  ;

  int apply(int a, int b) {
    return switch (this) {
      plus => a + b,
      multiply => a * b,
      concatenate => int.parse('$a$b'),
    };
  }
}

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<(int, List<int>)> parseInput() {
    final lines = <(int, List<int>)>[];
    for (final line in input.getPerLine()) {
      if (line.isNotEmpty) {
        final result = int.parse(line.split(':').first);
        final parts = line.split(':').last.split(' ').map(int.tryParse);

        lines.add((result, parts.nonNulls.toList()));
      }
    }

    return lines;
  }

  @override
  int solvePart1() {
    final possibleLines = <int>[];

    for (final test in parseInput()) {
      final (testResult, parts) = test;

      final possibleOperations = List<List<Operator>>.generate(
        pow(2, parts.length - 1).toInt(),
        (index) => List<Operator>.generate(
          parts.length - 1,
          (i) => (index & (1 << i)) == 0 ? Operator.plus : Operator.multiply,
        ),
      );

      for (final operationOrder in possibleOperations) {
        int result = parts.first;
        for (final (index, operation) in operationOrder.indexed) {
          result = operation.apply(result, parts[index + 1]);
        }
        if (result == testResult) {
          possibleLines.add(testResult);
          break;
        }
      }
    }

    return possibleLines.fold(0, (previous, element) => previous + element);
  }

  @override
  int solvePart2() {
    final possibleLines = <int>[];

    for (final test in parseInput()) {
      final (testResult, parts) = test;

      final possibleOperations = List<List<Operator>>.generate(
        pow(Operator.values.length, parts.length - 1).toInt(),
        (index) => List<Operator>.generate(
          parts.length - 1,
          (i) => Operator.values[(index ~/ pow(Operator.values.length, i)) %
              Operator.values.length],
        ),
      ).toSet();

      for (final operationOrder in possibleOperations) {
        int result = parts.first;
        for (final (index, operation) in operationOrder.indexed) {
          result = operation.apply(result, parts[index + 1]);
        }
        if (result == testResult) {
          possibleLines.add(testResult);
          break;
        }
      }
    }

    return possibleLines.fold(0, (previous, element) => previous + element);
  }
}

import '../utils/index.dart';
import 'helpers/instruction.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  String parseInput() {
    return input.asString;
  }

  @override
  int solvePart1() {
    int result = 0;

    [
      MultiplyInstruction(
        act: (value) => result += value,
      ),
    ].checkInput(parseInput());

    return result;
  }

  @override
  int solvePart2() {
    int result = 0;
    bool multiply = true;

    [
      DoInstrcuction(act: (_) => multiply = true),
      DontInstruction(act: (_) => multiply = false),
      MultiplyInstruction(
        act: (value) {
          if (multiply) {
            result += value;
          }
        },
      ),
    ].checkInput(parseInput());

    return result;
  }
}

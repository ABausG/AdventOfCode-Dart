extension InstrucionExtensions on List<Instruction<dynamic>> {
  void checkInput(String input) {
    for (int i = 0; i < input.length; i++) {
      final checkedInput = input.substring(i);
      for (final command in this) {
        command.check(checkedInput);
      }
    }
  }
}

sealed class Instruction<T> {
  Instruction._({
    required this.regex,
    required this.act,
  });

  final RegExp regex;
  void Function(T) act;

  T parse(Match match);

  void check(String argument) {
    final match = regex.matchAsPrefix(argument);
    if (match != null) {
      act(parse(match));
    }
  }
}

class DoInstrcuction extends Instruction<void> {
  DoInstrcuction({required super.act})
      : super._(
          regex: RegExp(r'do\(\)'),
        );

  @override
  void parse(Match match) {}
}

class DontInstruction extends Instruction<void> {
  DontInstruction({required super.act})
      : super._(
          regex: RegExp(r"don't\(\)"),
        );

  @override
  void parse(Match match) {}
}

class MultiplyInstruction extends Instruction<int> {
  MultiplyInstruction({required super.act})
      : super._(
          regex: RegExp(r'mul\(([\d]{1,3}),([\d]{1,3})\)'),
        );

  @override
  int parse(Match match) {
    final groups = match.groups([1, 2]);
    final a = int.parse(groups[0]!);
    final b = int.parse(groups[1]!);
    return a * b;
  }
}

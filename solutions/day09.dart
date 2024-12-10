import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<int> parseInput() {
    return input
        .getPerLine()
        .firstWhere((line) => line.isNotEmpty)
        .split('')
        .map(int.parse)
        .toList();
  }

  @override
  int solvePart1() {
    // Treat . from example as -1
    const placeholder = -1;
    final dottedVariant = <int>[];

    int fileId = 0;
    final input = parseInput();
    for (final (index, number) in input.indexed) {
      if (index.isEven) {
        dottedVariant.addAll(List.generate(number, (_) => fileId));
        fileId++;
      } else {
        dottedVariant.addAll(List.generate(number, (_) => placeholder));
      }
    }

    final result = <int>[];
    while (dottedVariant.isNotEmpty) {
      final number = dottedVariant.removeAt(0);
      final int numberToAdd;
      if (number != placeholder) {
        numberToAdd = number;
      } else {
        final lastNumberIndex =
            dottedVariant.lastIndexWhere((number) => number != placeholder);
        if (lastNumberIndex == -1) {
          break;
        }
        numberToAdd = dottedVariant.removeAt(lastNumberIndex);
      }

      result.add(numberToAdd);
    }

    int checksum = 0;

    for (final (index, number) in result.indexed) {
      checksum += index * number;
    }
    return checksum;
  }

  @override
  int solvePart2() {
    final input = parseInput();

    List<Part> parts = [];

    for (final (index, number) in input.indexed) {
      if (index.isEven) {
        parts.add(Data(length: number, value: index ~/ 2));
      } else {
        parts.add(Free(length: number));
      }
    }

    print('Sorting ${parts.length} parts');

    int lastSorted = parts.length;
    while (parts.isNotEmpty) {
      final lastDataBlockIndex = parts.lastIndexWhere((block) {
        return block is Data &&
            parts.indexOf(block) < lastSorted &&
            parts.any(
              (testBlock) =>
                  testBlock is Free && testBlock.length >= block.length,
            );
      });
      if (lastDataBlockIndex == -1) {
        break;
      }
      final block = parts[lastDataBlockIndex];

      final firstFreeBlockIndex = parts.indexWhere((freeBlock) {
        return freeBlock is Free && freeBlock.length >= block.length;
      });

      if (firstFreeBlockIndex == -1) {
        break;
      }

      if (lastDataBlockIndex < firstFreeBlockIndex) {
        lastSorted = lastDataBlockIndex;
        if (lastDataBlockIndex == 0) {
          break;
        } else {
          continue;
        }
      }
      final freeBlock = parts[firstFreeBlockIndex];

      parts = [
        ...parts.sublist(0, firstFreeBlockIndex),
        parts[lastDataBlockIndex],
        if (block.length < freeBlock.length)
          Free(length: freeBlock.length - block.length),
        ...parts.sublist(firstFreeBlockIndex + 1, lastDataBlockIndex),
        Free(length: block.length),
        ...parts.sublist(lastDataBlockIndex + 1),
      ];
      if (block.length < freeBlock.length) {
        lastSorted = lastDataBlockIndex + 1;
      } else {
        lastSorted = lastDataBlockIndex;
      }

      //print(parts.join());
    }

    // Output
    // 0099.111777244.333....5555.6666.....8888..
    // 00992111777.44.333....5555.6666.....8888..

    final spread = <int>[];
    for (final part in parts) {
      spread.addAll(List.generate(part.length, (_) => part.value));
    }

    // Spread
    // 0099211177744.333..5555.6666..8888
    // 00992111777.44.333....5555.6666.....8888..
    int checksum = 0;
    for (final (index, number) in spread.indexed) {
      if (number != -1) {
        checksum += index * number;
      }
    }

    return checksum;
  }
}

sealed class Part {
  const Part({required this.length, required this.value});

  final int length;
  final int value;
}

class Data extends Part {
  const Data({required super.length, required super.value});

  @override
  String toString() {
    return '$value' * length;
  }
}

class Free extends Part {
  const Free({required super.length}) : super(value: -1);

  @override
  String toString() {
    return '.' * length;
  }
}

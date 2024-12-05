import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  (List<(int, int)>, List<List<int>>) parseInput() {
    final lines = input.getPerLine();

    final sortOrders = <(int, int)>[];
    final pages = <List<int>>[];

    for (final line in lines) {
      if (line.isEmpty) {
        continue;
      }

      if (line.contains('|')) {
        final parts = line.split('|');
        sortOrders.add((int.parse(parts[0]), int.parse(parts[1])));
      } else {
        final numbers = line.split(',').map(int.parse).toList();

        pages.add(numbers);
      }
    }

    return (sortOrders, pages);
  }

  @override
  int solvePart1() {
    final (sortOrders, pages) = parseInput();

    final List<List<int>> sortedPages = List.from(pages);

    for (final page in pages) {
      for (final (index, number) in page.indexed) {
        final matchingInstructions = sortOrders.where((instruction) {
          final (start, end) = instruction;
          return start == number && page.contains(end);
        });

        for (final (_, end) in matchingInstructions) {
          final endIndex = page.indexOf(end);

          if (endIndex < index) {
            sortedPages.remove(page);
          }
        }
      }
    }

    print('Found ${sortedPages.length} sorted pages');

    int middleSum = 0;

    for (final page in sortedPages) {
      final middleIndex = page.length ~/ 2;
      middleSum += page[middleIndex];
    }

    return middleSum;
  }

  (bool, List<int>) sortList(List<int> list, List<(int, int)> sortOrders) {
    bool didSort = false;
    final List<int> sortedList = List.from(list);

    for (final (index, number) in list.indexed) {
      final matchingInstructions = sortOrders.where((instruction) {
        final (start, end) = instruction;
        return start == number && list.contains(end);
      });

      for (final (_, end) in matchingInstructions) {
        final endIndex = list.indexOf(end);

        if (endIndex < index) {
          didSort = true;
          sortedList
            ..remove(end)
            ..insert(index, end);
        }
      }
    }

    return (didSort, sortedList);
  }

  @override
  int solvePart2() {
    final (sortOrders, pages) = parseInput();

    final List<List<int>> sortedPages = [];
    for (final page in pages) {
      int sortCount = 1;
      List<int> restortedList;

      final (didSortList, sortedList) = sortList(page, sortOrders);

      bool needsSorting = didSortList;
      restortedList = sortedList;
      while (needsSorting) {
        final (didSort, sortedList) = sortList(restortedList, sortOrders);
        needsSorting = didSort;
        restortedList = sortedList;
        sortCount++;
        print('Sorted $sortCount times');
      }

      if (didSortList) {
        sortedPages.add(restortedList);
      }
    }

    print('Found ${sortedPages.length} re-sorted pages');

    int middleSum = 0;

    for (final page in sortedPages) {
      assert(page.length.isOdd);
      final middleIndex = page.length ~/ 2;
      middleSum += page[middleIndex];
    }

    return middleSum;
  }
}

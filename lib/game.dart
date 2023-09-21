import './cell.dart';
import 'dart:math';

List<List<Cell>> generateCells(List<int> size) {
  return List.generate(size[1],
      (col) => List.generate(size[0], (row) => Cell(coordinate: [row, col])));
}

class Game {
  List<int> size;
  int mineCount;
  List<List<Cell>> ground;
  Game({required this.size, required this.mineCount})
      : ground = generateCells(size);

  /// 统计已经翻开的方格
  int _openedCount = 0;

  /// 统计已经标记的方格
  int _markedCount = 0;

  bool ended = false;

  bool win = false;

  reset() {
    _openedCount = 0;
    _markedCount = 0;
    ended = false;
    ground = generateCells(size);
    createRandomMines();
  }

  /// 将某个格子周围的格子数目 +1
  void addCellCount(List<int> coordinate) {
    for (int xOffset = -1; xOffset <= 1; xOffset++) {
      for (int yOffset = -1; yOffset <= 1; yOffset++) {
        int x = coordinate[0] + xOffset;
        int y = coordinate[1] + yOffset;
        if (x < 0 || x >= size[0] || y < 0 || y >= size[1]) continue;
        ground[y][x].increaseCount();
      }
    }
  }

  /// 随机放置地雷
  void createRandomMines() {
    int currentMineCount = 0;
    while (currentMineCount < mineCount) {
      int x = Random().nextInt(size[0]);
      int y = Random().nextInt(size[1]);
      if (ground[y][x].mine) continue;
      ground[y][x].layMine();
      currentMineCount++;
      addCellCount([x, y]);
    }
  }

  /// 递归翻开方格
  void _openCellsRecursively(List<int> coordinate) {
    int x = coordinate[0];
    int y = coordinate[1];
    if (x < 0 || x >= size[0] || y < 0 || y >= size[1]) return;
    Cell cell = ground[y][x];
    if (!cell.openable) return;
    cell.setStatus(CellStatus.opened);
    if (cell.mine) ended = true;
    _openedCount++;
    if (cell.num == 0) {
      [
        [x + 1, y],
        [x - 1, y],
        [x, y + 1],
        [x, y - 1],
        [x + 1, y + 1],
        [x - 1, y - 1],
        [x + 1, y - 1],
        [x - 1, y + 1]
      ].forEach((element) {
        _openCellsRecursively(element);
      });
    }
  }

  bool _judge() {
    if (_markedCount == mineCount &&
        _markedCount + _openedCount == size[0] * size[1]) return true;
    return false;
  }

  void openCell(List<int> coordinate) {
    if (ended) return;
    _openCellsRecursively(coordinate);
    if (_judge()) {
      ended = true;
      win = true;
    }
  }

  void toggleMarkCell(List<int> coordinate) {
    Cell cell = ground[coordinate[1]][coordinate[0]];
    if (cell.status == CellStatus.marked) {
      cell.setStatus(CellStatus.initial);
      _markedCount--;
    } else if (cell.status == CellStatus.initial) {
      cell.setStatus(CellStatus.marked);
      _markedCount++;
    } else {
      return;
    }
  }
}

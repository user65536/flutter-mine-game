enum CellStatus { initial, marked, opened }

class Cell {
  /// 方格状态，初始未翻开、已翻开、已标记
  CellStatus status = CellStatus.initial;

  List<int> coordinate;

  late Function(void Function()) setStateCallback;

  Cell({required this.coordinate});

  /// 方格是否有雷
  bool mine = false;

  /// 方格的数字，代表周围的雷数目
  int num = 0;

  int get x {
    return coordinate[0];
  }

  int get y {
    return coordinate[1];
  }

  bool get openable {
    return status == CellStatus.initial;
  }

  /// 接收 setState 更新视图状态
  void setSetStateCallback(Function(void Function()) callback) {
    setStateCallback = callback;
  }

  void setStatus(CellStatus status) {
    setStateCallback(() {
      this.status = status;
    });
  }

  increaseCount() {
    num++;
  }

  layMine() {
    mine = true;
  }
}

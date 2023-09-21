import 'package:flutter/material.dart';
import './game.dart';
import './cell.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatefulWidget {
  @override
  GameWidgetState createState() => GameWidgetState();
}

class GameWidgetState extends State<GameApp> {
  Game game = Game(size: [8, 8], mineCount: 6);

  @override
  void initState() {
    super.initState();
    game.reset();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mine Game'),
        ),
        body: Center(
          child: GridView.builder(
            itemCount: 8 * 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              int y = index ~/ 8;
              int x = index % 8;
              return CellWidget(cell: game.ground[y][x], game: game);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            game.reset();
          }),
          child: const Icon(Icons.replay_outlined),
        ),
      ),
    );
  }
}

class CellWidget extends StatefulWidget {
  Cell cell;
  Game game;
  CellWidget({required this.cell, required this.game});

  @override
  CellWidgetState createState() => CellWidgetState();
}

class CellWidgetState extends State<CellWidget> {
  String getText(Cell cell) {
    if (cell.status != CellStatus.opened) return '';
    if (cell.mine) {
      return '雷';
    } else if (cell.num > 0) {
      return '${cell.num}';
    } else {
      return '';
    }
  }

  Color getCellColor(Cell cell) {
    if (cell.status == CellStatus.marked) {
      return Colors.deepOrange;
    } else if (cell.status == CellStatus.opened) {
      return cell.mine ? Colors.red : Colors.white;
    } else {
      return Colors.blueGrey;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.cell.setSetStateCallback(setState);
  }

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.cell.setSetStateCallback(setState);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.game.openCell(widget.cell.coordinate),
      onLongPress: () => widget.game.toggleMarkCell(widget.cell.coordinate),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          color: getCellColor(widget.cell),
        ),
        child: Center(
            child: Text(
          getText(widget.cell),
          style: const TextStyle(
            fontSize: 20,
          ),
        )),
      ),
    );
  }
}

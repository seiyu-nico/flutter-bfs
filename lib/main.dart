// Dart imports:
import 'dart:collection';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_bfs/models/cell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<List<Cell>> maze;
  late Cell start;
  late Cell goal;

  @override
  void initState() {
    maze = getMaze();
    start = maze[1][1];
    goal = maze[3][6];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = getCellSize();

    return Scaffold(
      appBar: AppBar(
        title: const Text("迷路"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(),
                    children: maze
                        .map((line) => TableRow(
                              children: line
                                  .map(
                                    (Cell cell) => Container(
                                      height: cellSize,
                                      width: cellSize,
                                      decoration: BoxDecoration(
                                        color: cell.getColor(),
                                      ),
                                      child:
                                          Center(child: Text(cell.getText())),
                                    ),
                                  )
                                  .toList(),
                            ))
                        .toList()),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: breadthFirstSearch, child: const Text('開始'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> breadthFirstSearch() async {
    var queue = Queue<List<Cell>>();
    queue.add([start]);
    List<Cell> tmpQueue = [];
    List<Cell> currents = [];
    setState(() {
      start.visited = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    while (queue.isNotEmpty) {
      currents = queue.removeFirst();
      for (final current in currents) {
        //   // 4方向に移動できるか確認し、移動できる場合はキューに追加する
        int row = current.x;
        int col = current.y;
        var directions = [
          {'x': -1, 'y': 0},
          {'x': 0, 'y': -1},
          {'x': 1, 'y': 0},
          {'x': 0, 'y': 1},
        ];
        for (var direction in directions) {
          var newRow = row + direction['x']!;
          var newCol = col + direction['y']!;

          if (newRow < 0 ||
              newRow >= maze.length ||
              newCol < 0 ||
              newCol >= maze[0].length) {
            continue; // マップの範囲外の場合はスキップ
          }

          if (maze[newRow][newCol].value == '#' ||
              maze[newRow][newCol].visited) {
            continue; // 壁またはすでに訪問済みの場合はスキップ
          }

          // ここでは描画したくないのでsetStateはしない
          maze[newRow][newCol].visited = true;
          maze[newRow][newCol].parent = current;
          maze[newRow][newCol].distance = current.distance + 1;
          tmpQueue.add(maze[newRow][newCol]);
        }
      }

      if (tmpQueue.isNotEmpty) {
        queue.add([...tmpQueue]);
        tmpQueue = [];
      }
      // 描画の為にsetState実行
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (goal.parent == null) {
      // ゴールに到達できない場合
      return;
    }

    // ここから戻るように色を塗る
    setState(() {
      goal.shortest = true;
    });
    Cell route = goal.parent!;
    await Future.delayed(const Duration(milliseconds: 500));
    while (route.value != 'S') {
      setState(() {
        route.shortest = true;
      });
      route = route.parent!;
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setState(() {
      start.shortest = true;
    });
  }

  double getCellSize() {
    double deviceWidth = MediaQuery.of(context).size.width * 0.8;
    double deviceHeight = MediaQuery.of(context).size.height * 0.8;
    double cellWidth = deviceWidth / maze.length;
    double cellHeight = deviceHeight / maze.length;

    return math.min(cellWidth, cellHeight);
  }
}

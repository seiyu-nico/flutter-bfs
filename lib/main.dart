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
      debugShowCheckedModeBanner: false,
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

  static const duration = 200;

  @override
  void initState() {
    maze = getMaze();
    start =
        maze.expand((v) => v).toList().firstWhere((Cell v) => v.value == "S");
    goal =
        maze.expand((v) => v).toList().firstWhere((Cell v) => v.value == "G");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("迷路"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  buildCustomGrid(
                      n: maze.length,
                      availableHeight: constraints.maxHeight * 0.7),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: breadthFirstSearch, child: const Text('開始'))
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCustomGrid({required int n, required double availableHeight}) {
    final tileSize = availableHeight / n;

    return SizedBox(
      width: tileSize * n,
      height: tileSize * n,
      child: GridView.builder(
        itemCount: n * n,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: n,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          int x = index % n;
          int y = index ~/ n;

          return GridTile(
            child: Container(
              decoration: BoxDecoration(
                color: maze[y][x].getColor(),
              ),
              child: Center(child: Text(maze[y][x].getText())),
            ),
          );
        },
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
    await Future.delayed(const Duration(milliseconds: duration));

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
      await Future.delayed(const Duration(milliseconds: duration));
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
    await Future.delayed(const Duration(milliseconds: duration));
    while (route.value != 'S') {
      setState(() {
        route.shortest = true;
      });
      route = route.parent!;
      await Future.delayed(const Duration(milliseconds: duration));
    }
    setState(() {
      start.shortest = true;
    });
  }
}

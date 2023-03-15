// Dart imports:
import 'dart:collection';
import 'dart:convert';

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
    // List<Cell>? res = breadthFirstSearch(maze, start, goal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("迷路"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 1000,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: maze[0].length, // グリッドの列数
                  children:
                      List.generate(maze.length * maze[0].length, // グリッドのセル数
                          (index) {
                    int x = index ~/ maze[0].length;
                    int y = index % maze[0].length;
                    return Container(
                      decoration: BoxDecoration(
                        color: maze[x][y].getColor(),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Center(child: Text(maze[x][y].getText())),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: breadthFirstSearch, child: const Text('開始'))
          ],
        ),
      ),
    );
  }

  Future<List<Cell>?> breadthFirstSearch() async {
    var queue = Queue<Cell>();
    List<Cell> visited = [];
    Cell current = start;
    queue.add(start);
    setState(() {
      start.visited = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    while (queue.isNotEmpty) {
      current = queue.removeFirst();

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

        if (maze[newRow][newCol].value == '#' || maze[newRow][newCol].visited) {
          continue; // 壁またはすでに訪問済みの場合はスキップ
        }

        setState(() {
          maze[newRow][newCol].visited = true;
          maze[newRow][newCol].parent = current;
          maze[newRow][newCol].distance = current.distance + 1;
        });
        queue.add(maze[newRow][newCol]);
        visited.add(maze[newRow][newCol]);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    // ここから戻るように色を塗る
    if (goal.parent == null) {
      return null;
    }

    setState(() {
      goal.shortest = true;
    });
    current = goal.parent!;
    await Future.delayed(const Duration(milliseconds: 500));
    while (current.value != 'S') {
      setState(() {
        current.shortest = true;
      });
      current = current.parent!;
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setState(() {
      start.shortest = true;
    });
    // ゴールに到達できない場合
    return null;
  }
}

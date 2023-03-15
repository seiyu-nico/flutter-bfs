// // Flutter imports:
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// Dart imports:
import 'dart:collection';

void main() {
  List<List<String>> maze = [
    ['#', '#', '#', '#', '#', '#', '#', '#'],
    ['#', '.', '.', '.', '#', '.', '.', '#'],
    ['#', '.', '#', '.', '#', '.', '#', '#'],
    ['#', '.', '#', '.', '.', '.', '.', '#'],
    ['#', '#', '#', '#', '#', '#', '#', '#']
  ];

  Map<String, int> start = {'x': 1, 'y': 1};
  Map<String, int> goal = {'x': 3, 'y': 6};

  List<Map<String, int>>? res = breadthFirstSearch(maze, start, goal);
  print(res);
}

List<Map<String, int>>? breadthFirstSearch(
    List<List<String>> maze, Map<String, int> start, Map<String, int> goal) {
  var queue = Queue<Map<String, int>>();
  List<Map<String, int>> visited = [];
  Map<String, Map<String, int>> parents = {};

  queue.add(start);
  visited.add(start);

  while (queue.isNotEmpty) {
    var current = queue.removeFirst();

    if (current["x"] == goal["x"] && current["y"] == goal["y"]) {
      // ゴールに到達した場合、最短経路を返す
      var path = [current];
      print(parents);
      while (current != start) {
        current = parents["${current["x"]}-${current["y"]}"]!;
        path.insert(0, current);
      }
      return path;
    }

    //   // 4方向に移動できるか確認し、移動できる場合はキューに追加する
    int row = current['x']!;
    int col = current['y']!;
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
        // print('マップ外');
        // print("x: $newRow, y: $newCol");
        continue; // マップの範囲外の場合はスキップ
      }

      if (maze[newRow][newCol] == '#' ||
          visited.indexWhere((v) => v["x"] == newRow && v['y'] == newCol) !=
              -1) {
        // print('壁 or 訪れた');
        // print("x: $newRow, y: $newCol");
        continue; // 壁またはすでに訪問済みの場合はスキップ
      }

      queue.add({'x': newRow, 'y': newCol});
      visited.add({'x': newRow, 'y': newCol});
      parents["$newRow-$newCol"] = current;
    }
  }

  // ゴールに到達できない場合
  return null;
}

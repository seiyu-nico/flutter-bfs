// Flutter imports:
import 'package:flutter/material.dart';

class Cell {
  int x;
  int y;
  String value;
  bool shortest;
  int distance;
  Cell? parent;
  bool visited;

  Cell({
    required this.x,
    required this.y,
    required this.value,
    this.shortest = false,
    this.visited = false,
    this.distance = 0,
    this.parent,
  });

  String getText() {
    if (value == 'S') {
      return 'S';
    } else if (value == 'G') {
      return 'G';
    }
    return distance == 0 ? '' : distance.toString();
  }

  Color getColor() {
    if (shortest) {
      return Colors.red;
    }
    if (visited) {
      return Colors.blue;
    } else if (value == '#') {
      return Colors.black;
    }
    return Colors.white;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = x;
    data['y'] = y;
    data['distance'] = distance;
    data['shortest'] = shortest;
    data['visited'] = visited;
    data['value'] = value;
    data['parent'] = parent?.toJson();
    return data;
  }
}

List<List<Cell>> getMaze() {
  return [
    [
      Cell(x: 0, y: 0, value: '#'),
      Cell(x: 0, y: 1, value: '#'),
      Cell(x: 0, y: 2, value: '#'),
      Cell(x: 0, y: 3, value: '#'),
      Cell(x: 0, y: 4, value: '#'),
      Cell(x: 0, y: 5, value: '#'),
      Cell(x: 0, y: 6, value: '#'),
      Cell(x: 0, y: 7, value: '#')
    ],
    [
      Cell(x: 1, y: 0, value: '#'),
      Cell(x: 1, y: 1, value: 'S', distance: 0),
      Cell(x: 1, y: 2, value: ''),
      Cell(x: 1, y: 3, value: ''),
      Cell(x: 1, y: 4, value: '#'),
      Cell(x: 1, y: 5, value: ''),
      Cell(x: 1, y: 6, value: ''),
      Cell(x: 1, y: 7, value: '#')
    ],
    [
      Cell(x: 2, y: 0, value: '#'),
      Cell(x: 2, y: 1, value: ''),
      Cell(x: 2, y: 2, value: '#'),
      Cell(x: 2, y: 3, value: ''),
      Cell(x: 2, y: 4, value: '#'),
      Cell(x: 2, y: 5, value: ''),
      Cell(x: 2, y: 6, value: '#'),
      Cell(x: 2, y: 7, value: '#')
    ],
    [
      Cell(x: 3, y: 0, value: '#'),
      Cell(x: 3, y: 1, value: ''),
      Cell(x: 3, y: 2, value: '#'),
      Cell(x: 3, y: 3, value: ''),
      Cell(x: 3, y: 4, value: ''),
      Cell(x: 3, y: 5, value: ''),
      Cell(x: 3, y: 6, value: 'G'),
      Cell(x: 3, y: 7, value: '#')
    ],
    [
      Cell(x: 4, y: 0, value: '#'),
      Cell(x: 4, y: 1, value: '#'),
      Cell(x: 4, y: 2, value: '#'),
      Cell(x: 4, y: 3, value: '#'),
      Cell(x: 4, y: 4, value: '#'),
      Cell(x: 4, y: 5, value: '#'),
      Cell(x: 4, y: 6, value: '#'),
      Cell(x: 4, y: 7, value: '#')
    ],
  ];
}

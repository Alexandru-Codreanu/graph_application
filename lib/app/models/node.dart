import 'package:flutter/material.dart';

class Node {
  final int id;
  Offset position;

  Node({
    required this.id,
    required this.position,
  });

  Node.fromJson({required dynamic json})
      : id = json['id'] as int,
        position = Offset(json['x'] as double, json['y'] as double);

  void updatePosition(double x, double y) {
    position = Offset(x, y);
  }
}

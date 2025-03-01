import 'dart:math';
import 'package:flutter/material.dart';
import '../models/graph.dart';

class GraphPainter extends CustomPainter {
  final Graph graph;
  final int selectedNode;

  GraphPainter({
    required this.graph,
    this.selectedNode = -1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _blankCanvas(canvas);
    _drawArcs(graph, canvas, size);
    _drawNodes(graph, canvas, size, selectedNode);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return !identical(this, oldDelegate);
  }
}

void _blankCanvas(Canvas canvas) {
  final Paint linePaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 0.25;

  canvas.drawColor(Colors.blueGrey.shade300, BlendMode.src);

  for (var i = 0; i < 30; i++) {
    canvas.drawLine(
      Offset(i * 50.0, 0.0),
      Offset(i * 50.0, 900),
      linePaint,
    );
  }

  for (var j = 0; j < 20; j++) {
    canvas.drawLine(
      Offset(0, j * 50.0),
      Offset(1500, j * 50.0),
      linePaint,
    );
  }
}

void _drawNodes(Graph graph, Canvas canvas, Size size, int selectedNode) {
  final nodePaint = Paint()
    ..color = Color.lerp(Colors.black, Colors.blue, 0.75)!
    ..style = PaintingStyle.fill;

  final selectedNodePaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  for (var i = 0; i < graph.nodes.length; i++) {
    canvas.drawCircle(graph.nodes[i].position, 10, nodePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: graph.nodes[i].id.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          shadows: [Shadow(color: Colors.black, blurRadius: 2.0)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final nodeOffset = Offset(graph.nodes[i].position.dx, graph.nodes[i].position.dy);
    final textOffset = Offset(nodeOffset.dx - (textPainter.width / 2), nodeOffset.dy - (textPainter.height / 2));

    textPainter.paint(canvas, textOffset);
  }

  if (selectedNode < 0 || selectedNode >= graph.nodes.length) {
    return;
  }

  canvas.drawCircle(graph.nodes[selectedNode].position, 10, selectedNodePaint);
}

void _drawArcs(Graph graph, Canvas canvas, Size size) {
  final Paint edgePaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1;

  for (var i = 0; i < graph.arcs.length; i++) {
    final start = graph.nodes[graph.arcs[i].firstNode].position;
    final end = graph.nodes[graph.arcs[i].secondNode].position;

    canvas.drawLine(start, end, edgePaint);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '${graph.arcs[i].flow}/${graph.arcs[i].capacity}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          shadows: [Shadow(color: Colors.black, blurRadius: 2.0)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final arcOffset = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final textOffset = Offset(arcOffset.dx - (textPainter.width / 2), arcOffset.dy - (textPainter.height / 2));

    textPainter.paint(canvas, textOffset);

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = sqrt(dx * dx + dy * dy);

    if (length > 0) {
      final ux = dx / length;
      final uy = dy / length;

      const arrowTipDistance = 10;
      final tip = Offset(
        end.dx - ux * arrowTipDistance,
        end.dy - uy * arrowTipDistance,
      );

      const arrowLength = 7.5;
      const arrowBaseWidth = 5;

      final back = Offset(
        tip.dx - ux * arrowLength,
        tip.dy - uy * arrowLength,
      );

      final perp = Offset(-uy * arrowBaseWidth, ux * arrowBaseWidth);
      final left = Offset(back.dx + perp.dx, back.dy + perp.dy);
      final right = Offset(back.dx - perp.dx, back.dy - perp.dy);

      final arrowPath = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(left.dx, left.dy)
        ..lineTo(right.dx, right.dy)
        ..close();

      final arrowPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      canvas.drawPath(arrowPath, arrowPaint);
    }
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/graph.dart';

class GraphPainter extends CustomPainter {
  final Graph graph;
  final int selectedNode;

  static final Paint linePaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 0.25;

  static final Paint nodePaint = Paint()
    ..color = Color.lerp(Colors.black, Colors.blue, 0.75)!
    ..style = PaintingStyle.fill;

  static final Paint selectedNodePaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  static final Paint edgePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  static final Paint pathPainter = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  static final arrowPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  static final pathArrowPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

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

  void _blankCanvas(Canvas canvas) {
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
    for (var i = 0; i < graph.arcs.length; i++) {
      final start = graph.nodes[graph.arcs[i].firstNode].position;
      final end = graph.nodes[graph.arcs[i].secondNode].position;

      // Calculate the midpoint of the line
      final midX = (start.dx + end.dx) / 2;
      final midY = (start.dy + end.dy) / 2;

      // Calculate the direction vector
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;

      // Calculate the perpendicular vector
      final perpX = -dy;
      final perpY = dx;

      // Normalize the perpendicular vector
      final length = sqrt(perpX * perpX + perpY * perpY);
      final normPerpX = perpX / length;
      final normPerpY = perpY / length;

      // Determine the curvature direction based on the arc direction
      final curvature = graph.isReversed(graph.arcs[i]) ? -10.0 : 10.0;

      // Calculate the control point for the quadratic Bezier curve
      final controlX = midX + normPerpX * curvature;
      final controlY = midY + normPerpY * curvature;

      // Draw the curved arc
      final path = Path();
      path.moveTo(start.dx, start.dy);
      path.quadraticBezierTo(controlX, controlY, end.dx, end.dy);
      path.quadraticBezierTo(controlX, controlY, start.dx, start.dy);
      path.close();
      canvas.drawPath(path, graph.arcs[i].isPath ? pathPainter : edgePaint);

      // Draw the arrow
      final dxArrow = end.dx - start.dx;
      final dyArrow = end.dy - start.dy;
      final lengthArrow = sqrt(dxArrow * dxArrow + dyArrow * dyArrow);

      if (lengthArrow > 0) {
        final ux = dxArrow / lengthArrow;
        final uy = dyArrow / lengthArrow;

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

        canvas.drawPath(arrowPath, graph.arcs[i].isPath ? pathArrowPaint : arrowPaint);
      }

      // Draw the text
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

      final arcOffset = Offset((start.dx + end.dx) / 2 + normPerpX * curvature * 2, (start.dy + end.dy) / 2 + normPerpY * curvature * 2);
      final textOffset = Offset(arcOffset.dx - (textPainter.width / 2), arcOffset.dy - (textPainter.height / 2));

      textPainter.paint(canvas, textOffset);
    }
  }
}

import 'package:flutter/material.dart';
import '../controllers/graph_controller.dart';
import 'graph_widget_holder.dart';
import 'side_panel.dart';

class GraphScreen extends StatefulWidget {
  final GraphController controller;
  const GraphScreen({super.key, required this.controller});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Color.lerp(Colors.black, Colors.blue, 0.25),
        type: MaterialType.canvas,
        child: Row(
          children: [
            Expanded(
              flex: 0,
              child: SidePanel(controller: widget.controller),
            ),
            Expanded(
              child: GraphWidgetHolder(controller: widget.controller),
            ),
          ],
        ),
      ),
    );
  }
}

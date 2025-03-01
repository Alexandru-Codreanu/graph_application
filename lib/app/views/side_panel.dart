import 'package:flutter/material.dart';
import '../controllers/graph_controller.dart';
import 'options/file_input_option.dart';
import 'options/first_node_selected_indicator.dart';
import 'options/mode_selector_option.dart';

class SidePanel extends StatefulWidget {
  final GraphController controller;
  const SidePanel({
    super.key,
    required this.controller,
  });

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size.fromWidth(200),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Text(
              "Options",
              style: TextStyle(
                color: Color.lerp(Colors.white, Colors.blue, 0.5),
                fontSize: 24,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ModeSelectorOption(controller: widget.controller),
                    FirstNodeSelectedIndicator(controller: widget.controller),
                    FileInputOption(controller: widget.controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

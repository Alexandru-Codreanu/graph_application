import 'package:flutter/material.dart';
import '../../controllers/graph_controller.dart';
import 'multiple_item_selector.dart';
import 'options_holder.dart';

class ModeSelectorOption extends StatefulWidget {
  final GraphController controller;

  const ModeSelectorOption({
    super.key,
    required this.controller,
  });

  @override
  State<ModeSelectorOption> createState() => _ModeSelectorOptionState();
}

class _ModeSelectorOptionState extends State<ModeSelectorOption> {
  @override
  Widget build(BuildContext context) {
    return OptionsHolder(
      title: "Interaction Mode",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: MultipleItemSelector(
              listenable: widget.controller.interactionModeNotifier,
              onChange: (value) {
                widget.controller.interactionMode = value;
              },
            ),
          )
        ],
      ),
    );
  }
}

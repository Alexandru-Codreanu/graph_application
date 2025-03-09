import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controllers/algorithms.dart';
import '../../controllers/graph_controller.dart';
import 'options_holder.dart';
import 'simple_option_button.dart';

class AlgorithmsOption extends StatefulWidget {
  final GraphController controller;

  const AlgorithmsOption({
    super.key,
    required this.controller,
  });

  @override
  State<AlgorithmsOption> createState() => _AlgorithmsOptionState();
}

class _AlgorithmsOptionState extends State<AlgorithmsOption> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller.isLoadingNotifier]),
      builder: (context, child) => OptionsHolder(
        title: "Algorithms",
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              SimpleOptionButton(
                  icon: Icons.import_export_sharp,
                  label: "Generic",
                  onTap: widget.controller.isLoading
                      ? null
                      : () async {
                          widget.controller.isLoading = true;

                          await compute(IsolateAlgorithms.generic, {
                            "nodes": widget.controller.graph.nodes,
                            "arcs": widget.controller.graph.arcs,
                            "start": 0,
                            "end": widget.controller.graph.nodes.last.id,
                          }).then(
                            (value) {
                              widget.controller.graph.copyGraph(value.$1);
                              log(value.$2.toString());
                            },
                          );

                          widget.controller.isLoading = false;
                          return;
                        }),
            ],
          ),
        ),
      ),
    );
  }
}

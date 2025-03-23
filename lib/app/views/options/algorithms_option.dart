import 'dart:developer';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controllers/algorithms.dart';
import '../../controllers/graph_controller.dart';
import '../../models/graph.dart';
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
                          final ReceivePort receivePort = ReceivePort();
                          receivePort.listen(
                            (message) {
                              if (message is! Graph) {
                                log(message);
                                return;
                              }
                              widget.controller.graph.copyGraph(message);
                            },
                          );
                          Isolate.spawn(IsolateAlgorithms.generic, {
                            "nodes": widget.controller.graph.nodes,
                            "arcs": widget.controller.graph.arcs,
                            "start": 0,
                            "end": widget.controller.graph.nodes.last.id,
                            "port": receivePort.sendPort,
                          }).then(
                            (value) {
                              widget.controller.isLoading = false;
                            },
                          );

                          await compute(IsolateAlgorithms.generic, {
                            "nodes": widget.controller.graph.nodes,
                            "arcs": widget.controller.graph.arcs,
                            "start": 0,
                            "end": widget.controller.graph.nodes.last.id,
                            "port": receivePort.sendPort,
                          }).then(
                            (value) {
                              widget.controller.graph.copyGraph(value);
                              widget.controller.isLoading = false;
                            },
                          );

                          return;
                        }),
              SimpleOptionButton(
                icon: Icons.import_export_sharp,
                label: "Ford Fulkerson",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;

                        await compute(IsolateAlgorithms.fordFulkerson, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": 0,
                          "end": widget.controller.graph.nodes.last.id,
                        }).then(
                          (value) {
                            widget.controller.graph.copyGraph(value);
                          },
                        );

                        widget.controller.isLoading = false;
                        return;
                      },
              ),
              SimpleOptionButton(
                icon: Icons.import_export_sharp,
                label: "Edmonds Karp",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;

                        await compute(IsolateAlgorithms.edmondsKarp, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": 0,
                          "end": widget.controller.graph.nodes.last.id,
                        }).then(
                          (value) {
                            widget.controller.graph.copyGraph(value);
                          },
                        );

                        widget.controller.isLoading = false;
                        return;
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

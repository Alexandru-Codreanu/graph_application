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
                            "start": widget.controller.graph.nodes.first.id,
                            "end": widget.controller.graph.nodes.last.id,
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
                          "start": widget.controller.graph.nodes.first.id,
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
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Maximum Scale",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;

                        await compute(IsolateAlgorithms.maximumScale, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Bit Scale",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;

                        await compute(IsolateAlgorithms.bitScale, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Ahuja-Orlin",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.shortPathAhujaOrlin, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Ahuja-Orlin(B)",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.shortPathAhujaOrlinB, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Ahuja-Orlin(S)",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.stratifiedAhujaOrlin, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Generic Preflux",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.genericPreflux, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Preflux FiFo",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.prefluxFiFo, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Preflux Priority",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.prefluxHeap, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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
                label: "Excessive scaling",
                onTap: widget.controller.isLoading
                    ? null
                    : () async {
                        widget.controller.isLoading = true;
                        await compute(IsolateAlgorithms.excessScaling, {
                          "nodes": widget.controller.graph.nodes,
                          "arcs": widget.controller.graph.arcs,
                          "start": widget.controller.graph.nodes.first.id,
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

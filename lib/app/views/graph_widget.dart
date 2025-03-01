import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controllers/graph_controller.dart';
import '../controllers/operations.dart';
import '../models/arc.dart';
import '../models/mode_enum.dart';
import 'graph_painter.dart';
import '../models/node.dart';
import 'options/number_picker.dart';
import 'options/simple_option_button.dart';

class GraphWidget extends StatefulWidget {
  final GraphController controller;

  const GraphWidget({
    super.key,
    required this.controller,
  });

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  int dragIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller.interactionModeNotifier, widget.controller.graphNotifier]),
      builder: (context, child) {
        return InteractiveViewer(
          minScale: 0.001,
          maxScale: 10,
          panEnabled: widget.controller.interactionMode == InteractionMode.freeMove,
          scaleEnabled: widget.controller.interactionMode == InteractionMode.freeMove,
          child: switch (widget.controller.interactionMode) {
            InteractionMode.freeMove => child!,
            InteractionMode.dragNodes => GestureDetector(
                child: child!,
                onPanStart: (details) {
                  for (var i = 0; i < widget.controller.graph.nodes.length; i++) {
                    if ((widget.controller.graph.nodes[i].position - details.localPosition).distance > 20.0) {
                      continue;
                    }

                    dragIndex = i;
                    return;
                  }
                },
                onPanUpdate: (details) {
                  if (dragIndex == -1) {
                    return;
                  }

                  widget.controller.graph.updateNodePositon(dragIndex, details.localPosition);
                },
                onPanCancel: () {
                  dragIndex = -1;
                },
                onPanEnd: (details) {
                  dragIndex = -1;
                },
              ),
            InteractionMode.editGraph => GestureDetector(
                child: child!,
                onTapUp: (details) {
                  widget.controller.isLoading = true;
                  compute(IsolateOperations.nodeExistsInProximity, {
                    'nodes': widget.controller.graph.nodes,
                    'position': details.localPosition,
                  }).then(
                    (value) {
                      if (!value) {
                        widget.controller.graph.addNode(
                          Node(id: widget.controller.graph.nodes.length, position: details.localPosition),
                        );
                      }
                      widget.controller.isLoading = false;
                    },
                  );
                },
                onSecondaryTapUp: (details) async {
                  widget.controller.isLoading = true;
                  final bool wasNoneSelected = widget.controller.firstNodeInArchSelected <= -1;

                  final int newIndex = await compute(IsolateOperations.findNodeInProximity, {
                    'nodes': widget.controller.graph.nodes,
                    'position': details.localPosition,
                  });

                  if (newIndex <= -1) {
                    widget.controller.isLoading = false;
                    return;
                  }

                  if (wasNoneSelected) {
                    widget.controller.firstNodeInArchSelected = newIndex;
                    widget.controller.isLoading = false;
                    return;
                  }

                  final (int, bool) result = await compute(IsolateOperations.findArcByNodes, {
                    'arcs': widget.controller.graph.arcs,
                    'firstNode': widget.controller.firstNodeInArchSelected,
                    'secondNode': newIndex,
                  });

                  if (!context.mounted) {
                    widget.controller.isLoading = false;
                    return;
                  }

                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Center(
                      child: SizedBox.fromSize(
                        size: const Size(200, 150),
                        child: Material(
                          type: MaterialType.card,
                          color: Color.lerp(Colors.white, Colors.blue, 0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(7.5),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(7.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (result.$1 <= -1)
                                SimpleOptionButton(
                                  icon: Icons.add,
                                  label: "Create new arc",
                                  onTap: () async {
                                    TextEditingController capacityController = TextEditingController();
                                    TextEditingController flowController = TextEditingController();
                                    await showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: SizedBox.fromSize(
                                          size: const Size(200, 200),
                                          child: Material(
                                            type: MaterialType.card,
                                            color: Color.lerp(Colors.white, Colors.blue, 0.5),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(7.5),
                                              bottomRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(7.5),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                NumberPicker(
                                                  controller: flowController,
                                                  hint: 'flow',
                                                ),
                                                NumberPicker(
                                                  controller: capacityController,
                                                  hint: 'capacity',
                                                ),
                                                SimpleOptionButton(
                                                  icon: Icons.check_circle_outline,
                                                  label: "Confirm",
                                                  onTap: () {
                                                    capacityController.text += capacityController.text.isEmpty ? '0.0' : '';
                                                    flowController.text += flowController.text.isEmpty ? '0.0' : '';
                                                    widget.controller.graph.addArc(
                                                      Arc(
                                                        firstNode: widget.controller.firstNodeInArchSelected,
                                                        secondNode: newIndex,
                                                        capacity: double.parse(capacityController.text),
                                                        flow: double.parse(flowController.text),
                                                      ),
                                                    );
                                                    widget.controller.firstNodeInArchSelected = -1;
                                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                                  },
                                                ),
                                                SimpleOptionButton(
                                                  icon: Icons.cancel_outlined,
                                                  label: "Cancel",
                                                  onTap: () {
                                                    widget.controller.firstNodeInArchSelected = -1;
                                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              if (result.$1 > -1 && result.$1 < widget.controller.graph.arcs.length)
                                SimpleOptionButton(
                                  icon: Icons.delete,
                                  label: "Delete existing",
                                  onTap: () {
                                    widget.controller.graph.deleteArc(result.$1);
                                    widget.controller.firstNodeInArchSelected = -1;
                                    Navigator.pop(context);
                                  },
                                ),
                              if (result.$1 > -1 && !result.$2)
                                SimpleOptionButton(
                                  icon: Icons.recycling_sharp,
                                  label: "Change direction",
                                  onTap: () {
                                    widget.controller.graph.updateArcDirection(result.$1);
                                    widget.controller.firstNodeInArchSelected = -1;
                                    Navigator.pop(context);
                                  },
                                ),
                              if (result.$1 > -1)
                                SimpleOptionButton(
                                  icon: Icons.add,
                                  label: "Edit existing arc",
                                  onTap: () async {
                                    TextEditingController capacityController =
                                        TextEditingController(text: widget.controller.graph.arcs[result.$1].capacity.toString());
                                    TextEditingController flowController = TextEditingController(text: widget.controller.graph.arcs[result.$1].flow.toString());
                                    await showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                        child: SizedBox.fromSize(
                                          size: const Size(200, 200),
                                          child: Material(
                                            type: MaterialType.card,
                                            color: Color.lerp(Colors.white, Colors.blue, 0.5),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(7.5),
                                              bottomRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(7.5),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                NumberPicker(
                                                  controller: flowController,
                                                  hint: 'flow',
                                                ),
                                                NumberPicker(
                                                  controller: capacityController,
                                                  hint: 'capacity',
                                                ),
                                                SimpleOptionButton(
                                                  icon: Icons.check_circle_outline,
                                                  label: "Confirm",
                                                  onTap: () {
                                                    capacityController.text += capacityController.text.isEmpty ? '0.0' : '';
                                                    flowController.text += flowController.text.isEmpty ? '0.0' : '';
                                                    widget.controller.graph.updateCapacityFlow(
                                                      result.$1,
                                                      double.parse(capacityController.text),
                                                      double.parse(flowController.text),
                                                    );

                                                    widget.controller.firstNodeInArchSelected = -1;
                                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                                  },
                                                ),
                                                SimpleOptionButton(
                                                  icon: Icons.cancel_outlined,
                                                  label: "Cancel",
                                                  onTap: () {
                                                    widget.controller.firstNodeInArchSelected = -1;
                                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              SimpleOptionButton(
                                icon: Icons.compare_arrows_sharp,
                                label: "Change node",
                                onTap: () {
                                  widget.controller.firstNodeInArchSelected = newIndex;
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleOptionButton(
                                icon: Icons.arrow_back_ios_sharp,
                                label: "Keep node",
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).then(
                    (value) {
                      widget.controller.isLoading = false;
                      return;
                    },
                  );
                },
              ),
          },
        );
      },
      child: ListenableBuilder(
        listenable: Listenable.merge([
          widget.controller.graph,
          widget.controller.graphNotifier,
          widget.controller.firstNodeInArchSelectedNotifier,
        ]),
        builder: (context, child) => CustomPaint(
          size: Size.infinite,
          painter: GraphPainter(graph: widget.controller.graph, selectedNode: widget.controller.firstNodeInArchSelected),
        ),
      ),
    );
  }
}

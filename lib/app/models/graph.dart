import 'package:flutter/material.dart';
import 'arc.dart';
import 'node.dart';

class Graph extends ChangeNotifier {
  final List<Node> nodes;
  final List<Arc> arcs;

  Graph({
    required this.nodes,
    required this.arcs,
  });

  void addNode(Node node) {
    nodes.add(node);
    notifyListeners();
  }

  void addArc(Arc arc) {
    arcs.add(arc);
    notifyListeners();
  }

  void updateNodePositon(int index, Offset position) {
    nodes[index].position = position;
    notifyListeners();
  }

  void updateArcDirection(int index) {
    final Arc arc = Arc(
      firstNode: arcs[index].secondNode,
      secondNode: arcs[index].firstNode,
      capacity: arcs[index].capacity,
      flow: arcs[index].flow,
    );

    arcs.removeAt(index);
    arcs.add(arc);

    notifyListeners();
  }

  void updateCapacityFlow(int index, double capacity, double flow) {
    final Arc arc = Arc(firstNode: arcs[index].firstNode, secondNode: arcs[index].secondNode, capacity: capacity, flow: flow);
    arcs.removeAt(index);
    arcs.add(arc);
    notifyListeners();
  }

  void deleteArc(int index) {
    arcs.removeAt(index);
    notifyListeners();
  }

  void deleteNode(int index) {
    nodes.removeAt(index);
    notifyListeners();
  }

  void addNodeList(List<Node> newNodes) {
    nodes.addAll(newNodes);
    notifyListeners();
  }

  void addArcsList(List<Arc> newArcs) {
    arcs.addAll(newArcs);
    notifyListeners();
  }

  void clearAll() {
    nodes.clear();
    arcs.clear();
    notifyListeners();
  }

  void copyGraph(Graph source) {
    arcs.clear();
    nodes.clear();
    arcs.addAll(source.arcs);
    nodes.addAll(source.nodes);
    notifyListeners();
  }

  Graph.fromJson({required dynamic json})
      : arcs = (json['arcs'] as List).map((element) => Arc.fromJson(json: element)).toList(),
        nodes = (json['nodes'] as List).map((element) => Node.fromJson(json: element)).toList();

  Graph.empty()
      : arcs = List<Arc>.empty(growable: true),
        nodes = List<Node>.empty(growable: true);
}

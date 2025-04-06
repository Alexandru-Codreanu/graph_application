import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'adjacency.dart';
import 'arc.dart';
import 'node.dart';

class Graph extends ChangeNotifier {
  final List<Node> nodes;
  final List<Arc> arcs;
  late Map<int, List<Adjacency>> adjacencyMap;

  Graph({
    required this.nodes,
    required this.arcs,
  }) {
    adjacencyMap = <int, List<Adjacency>>{};
    _initAdjacencyMap();
  }

  Graph.fromJson({required dynamic json})
      : arcs = (json['arcs'] as List).map((element) => Arc.fromJson(json: element)).toList(),
        nodes = (json['nodes'] as List).map((element) => Node.fromJson(json: element)).toList() {
    _initAdjacencyMap();
  }

  Graph.empty()
      : arcs = List<Arc>.empty(growable: true),
        nodes = List<Node>.empty(growable: true),
        adjacencyMap = <int, List<Adjacency>>{};

  List<int> randomTraversal(int start, int end) {
    List<int> parent = List<int>.filled(nodes.length, -1, growable: false);
    List<bool> visited = List<bool>.filled(nodes.length, false, growable: false);
    List<int> choices = List<int>.empty(growable: true);
    Random random = Random(DateTime.now().millisecondsSinceEpoch);

    visited[start] = true;
    choices.add(start);
    parent[start] = -1;

    while (choices.isNotEmpty) {
      int current = choices.removeAt(random.nextInt(choices.length));

      if (current == end) {
        List<int> path = [];
        current = end;
        while (current != -1) {
          path.add(current);
          current = parent[current];
        }
        return path.reversed.toList();
      }

      for (int i = 0; i < adjacencyMap[current]!.length; i++) {
        if (!visited[adjacencyMap[current]![i].secondNodeIndex] && arcs[adjacencyMap[current]![i].arcIndex].residualCapacity > 0) {
          visited[current] = true;
          parent[adjacencyMap[current]![i].secondNodeIndex] = current;
          choices.add(adjacencyMap[current]![i].secondNodeIndex);
        }
      }
    }

    return List.empty();
  }

  List<int> depthFirstSearch(int start, int end) {
    List<int> parent = List<int>.filled(nodes.length, -1, growable: false);
    List<bool> visited = List<bool>.filled(nodes.length, false, growable: false);
    Queue<int> queue = Queue<int>();

    visited[start] = true;
    queue.add(start);
    parent[start] = -1;

    while (queue.isNotEmpty) {
      int current = queue.removeFirst();

      if (current == end) {
        List<int> path = [];
        current = end;
        while (current != -1) {
          path.add(current);
          current = parent[current];
        }
        return path.reversed.toList();
      }

      for (int i = 0; i < adjacencyMap[current]!.length; i++) {
        if (!visited[adjacencyMap[current]![i].secondNodeIndex] && arcs[adjacencyMap[current]![i].arcIndex].residualCapacity > 0) {
          visited[current] = true;
          parent[adjacencyMap[current]![i].secondNodeIndex] = current;
          queue.add(adjacencyMap[current]![i].secondNodeIndex);
        }
      }
    }

    return List.empty();
  }

  List<int> breadthFirstSearchFF(int start, int end) {
    List<int> parent = List<int>.filled(nodes.length, -1, growable: false);
    List<bool> visited = List<bool>.filled(nodes.length, false, growable: false);
    List<int> choices = List<int>.empty(growable: true);
    Random random = Random(DateTime.now().millisecondsSinceEpoch);

    visited[start] = true;
    choices.add(start);
    parent[start] = -1;

    while (choices.isNotEmpty) {
      int current = choices.removeAt(random.nextInt(choices.length));

      if (current == end) {
        List<int> path = [];
        current = end;
        while (current != -1) {
          path.add(current);
          current = parent[current];
        }
        return path.reversed.toList();
      }

      for (int i = 0; i < adjacencyMap[current]!.length; i++) {
        if (!visited[adjacencyMap[current]![i].secondNodeIndex] && arcs[adjacencyMap[current]![i].arcIndex].residualCapacity > 0) {
          visited[current] = true;
          parent[adjacencyMap[current]![i].secondNodeIndex] = current;
          choices.add(adjacencyMap[current]![i].secondNodeIndex);
        }
      }
    }

    return List.empty();
  }

  List<int> breadthFirstSearchMS(int start, int end, double residual) {
    List<int> parent = List<int>.filled(nodes.length, -1, growable: false);
    List<bool> visited = List<bool>.filled(nodes.length, false, growable: false);
    Queue<int> queue = Queue<int>();

    visited[start] = true;
    queue.add(start);
    parent[start] = -1;

    while (queue.isNotEmpty) {
      int current = queue.removeLast();

      if (current == end) {
        List<int> path = [];
        current = end;
        while (current != -1) {
          path.add(current);
          current = parent[current];
        }
        return path.reversed.toList();
      }

      for (int i = 0; i < adjacencyMap[current]!.length; i++) {
        if (!visited[adjacencyMap[current]![i].secondNodeIndex] && arcs[adjacencyMap[current]![i].arcIndex].residualCapacity >= residual) {
          visited[current] = true;
          parent[adjacencyMap[current]![i].secondNodeIndex] = current;
          queue.add(adjacencyMap[current]![i].secondNodeIndex);
        }
      }
    }

    return List.empty();
  }

  List<int> breadthFirstSearch(int start, int end) {
    List<int> parent = List<int>.filled(nodes.length, -1, growable: false);
    List<bool> visited = List<bool>.filled(nodes.length, false, growable: false);
    Queue<int> queue = Queue<int>();

    visited[start] = true;
    queue.add(start);
    parent[start] = -1;

    while (queue.isNotEmpty) {
      int current = queue.removeLast();

      if (current == end) {
        List<int> path = [];
        current = end;
        while (current != -1) {
          path.add(current);
          current = parent[current];
        }
        return path.reversed.toList();
      }

      for (int i = 0; i < adjacencyMap[current]!.length; i++) {
        if (!visited[adjacencyMap[current]![i].secondNodeIndex] && arcs[adjacencyMap[current]![i].arcIndex].residualCapacity > 0) {
          visited[current] = true;
          parent[adjacencyMap[current]![i].secondNodeIndex] = current;
          queue.add(adjacencyMap[current]![i].secondNodeIndex);
        }
      }
    }

    return List.empty();
  }

  double minResidualValue(List<int> path) {
    double minResidual = double.maxFinite;
    while (path.length > 1) {
      int v = path.removeAt(0);
      int u = path[0];
      for (var i = 0; i < arcs.length; i++) {
        if (arcs[i].firstNode != v || arcs[i].secondNode != u) {
          continue;
        }

        if (arcs[i].residualCapacity > minResidual) {
          continue;
        }

        minResidual = arcs[i].residualCapacity;
        break;
      }
    }
    return minResidual;
  }

  void increaseWithResidual(double residual, List<int> path) {
    if (residual == double.maxFinite) {
      return;
    }

    while (path.length > 1) {
      int v = path.removeAt(0);
      int u = path[0];
      for (var i = 0; i < arcs.length; i++) {
        if (arcs[i].firstNode != v || arcs[i].secondNode != u) {
          continue;
        }

        arcs[i].flow += residual;
        break;
      }
    }
  }

  bool isReversed(Arc arc) {
    for (var i = 0; i < arcs.length; i++) {
      if (arcs[i].firstNode == arc.secondNode && arcs[i].secondNode == arc.firstNode) {
        return true;
      }
    }

    return false;
  }

  void _initAdjacencyMap() {
    adjacencyMap = <int, List<Adjacency>>{};
    for (int i = 0; i < nodes.length; i++) {
      adjacencyMap[nodes[i].id] = List<Adjacency>.empty(growable: true);
    }

    for (int i = 0; i < arcs.length; i++) {
      if (!adjacencyMap.containsKey(arcs[i].firstNode)) {
        throw Exception("Node ${arcs[i].firstNode} does not exist.");
      }
      adjacencyMap[arcs[i].firstNode]?.add(Adjacency(secondNodeIndex: arcs[i].secondNode, arcIndex: i));
    }
  }

  void addNode(Node node) {
    nodes.add(node);
    adjacencyMap[node.id] = List<Adjacency>.empty(growable: true);
    notifyListeners();
  }

  void addArc(Arc arc) {
    arcs.add(arc);
    adjacencyMap[arc.firstNode]?.add(Adjacency(secondNodeIndex: arc.secondNode, arcIndex: arcs.length - 1));
    notifyListeners();
  }

  void updateNodePositon(int index, Offset position) {
    nodes[index].position = position;
    notifyListeners();
  }

  void updateArcDirection(int index) {
    final aux = arcs[index].firstNode;
    adjacencyMap[arcs[index].secondNode]?.add(Adjacency(secondNodeIndex: arcs[index].firstNode, arcIndex: index));
    adjacencyMap[arcs[index].firstNode]?.remove(Adjacency(secondNodeIndex: arcs[index].secondNode, arcIndex: index));
    arcs[index].firstNode = arcs[index].secondNode;
    arcs[index].secondNode = aux;
    notifyListeners();
  }

  void updateCapacityFlow(int index, double capacity, double flow) {
    arcs[index]
      ..flow = flow
      ..capacity = capacity;

    notifyListeners();
  }

  void deleteArc(int index) {
    final removedArc = arcs.removeAt(index);
    adjacencyMap[removedArc.firstNode]?.remove(Adjacency(secondNodeIndex: removedArc.secondNode, arcIndex: index));
    notifyListeners();
  }

  void deleteNode(int index) {
    final removedNode = nodes.removeAt(index);
    final removedArcs = adjacencyMap.remove(removedNode.id);
    if (removedArcs?.isEmpty ?? true) {
      notifyListeners();
      return;
    }

    int removedCounter = 0;
    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].firstNode == removedNode.id) {
        arcs.removeAt(i);
        removedCounter++;

        if (removedCounter == removedArcs?.length) {
          break;
        }
      }
    }
    notifyListeners();
  }

  void addNodeList(List<Node> newNodes) {
    nodes.addAll(newNodes);
    for (var i = 0; i < newNodes.length; i++) {
      adjacencyMap[newNodes[i].id] = List<Adjacency>.empty(growable: true);
    }
    notifyListeners();
  }

  void addArcsList(List<Arc> newArcs) {
    arcs.addAll(newArcs);
    for (var i = 0; i < newArcs.length; i++) {
      adjacencyMap[newArcs[i].firstNode]?.add(Adjacency(secondNodeIndex: newArcs[i].secondNode, arcIndex: arcs.indexOf(newArcs[i])));
    }
    notifyListeners();
  }

  void clearAll() {
    nodes.clear();
    arcs.clear();
    adjacencyMap.clear();
    notifyListeners();
  }

  void copyGraph(Graph source) {
    arcs.clear();
    nodes.clear();
    adjacencyMap.clear();
    arcs.addAll(source.arcs);
    nodes.addAll(source.nodes);
    _initAdjacencyMap();
    notifyListeners();
  }

  void setFlowToZero() {
    for (var i = 0; i < arcs.length; i++) {
      arcs[i].flow = 0;
    }
    notifyListeners();
  }
}

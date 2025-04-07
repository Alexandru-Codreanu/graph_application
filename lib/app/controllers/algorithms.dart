import 'dart:math';
import '../models/arc.dart';
import '../models/graph.dart';
import '../models/node.dart';

abstract final class IsolateAlgorithms {
  static (Graph, int, int) handleInput(Map<String, Object> map) {
    final List<Node> nodes = map['nodes'] as List<Node>;
    final List<Arc> arcs = map['arcs'] as List<Arc>;
    final Graph graph = Graph(nodes: nodes, arcs: arcs);
    final int start = map['start'] as int;
    final int end = map['end'] as int;
    return (graph, start, end);
  }

  static Graph generic(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    double residual = double.maxFinite;
    List<int> augmentingPath = List.empty(growable: true);

    graph.setFlowToZero();
    do {
      augmentingPath = graph.randomTraversal(start, end);
      residual = graph.minResidualValue(augmentingPath.toList());
      graph.increaseWithResidual(residual, augmentingPath.toList());
    } while (augmentingPath.isNotEmpty);

    return graph;
  }

  static Graph fordFulkerson(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    double residual = double.maxFinite;
    List<int> augmentingPath = List.empty(growable: true);

    graph.setFlowToZero();
    do {
      augmentingPath = graph.breadthFirstSearchFF(start, end);
      residual = graph.minResidualValue(augmentingPath.toList());
      graph.increaseWithResidual(residual, augmentingPath.toList());
    } while (augmentingPath.isNotEmpty);

    return graph;
  }

  static Graph edmondsKarp(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    double residual = double.maxFinite;
    List<int> augmentingPath = List.empty(growable: true);

    graph.setFlowToZero();
    do {
      augmentingPath = graph.breadthFirstSearch(start, end);
      residual = graph.minResidualValue(augmentingPath.toList());
      graph.increaseWithResidual(residual, augmentingPath.toList());
    } while (augmentingPath.isNotEmpty);

    return graph;
  }

  static Graph maximumScale(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    List<int> augmentingPath = List.empty(growable: true);
    double pathResidual = double.maxFinite;

    graph.setFlowToZero();

    double maxCapacity = graph.arcs.map((e) => e.capacity).reduce(max);

    double residual = pow(2, log(maxCapacity).floor()).toDouble();

    while (residual >= 1) {
      print('r: $residual');
      do {
        augmentingPath = graph.breadthFirstSearchMS(start, end, residual);
        print('path: ${augmentingPath.toString()}');
        pathResidual = graph.minResidualValue(augmentingPath.toList());
        graph.increaseWithResidual(pathResidual, augmentingPath.toList());
      } while (augmentingPath.isNotEmpty);
      residual /= 2;
    }

    return graph;
  }

  static Graph bitScale(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    List<Graph> graphOfEachK = List<Graph>.empty(growable: true);
    int k = 0;

    graphOfEachK.add(graph);

    while (graphOfEachK[k].arcs.map((arc) => arc.capacity).reduce(max) > 1) {
      graphOfEachK.add(Graph.empty()..copyGraph(graphOfEachK.last));

      for (var i = 0; i < graphOfEachK[k].arcs.length; i++) {
        graphOfEachK[k + 1].arcs[i].capacity = (graphOfEachK[k].arcs[i].capacity / 2).floorToDouble();
      }

      k += 1;
    }

    while (k >= 0) {
      for (var i = 0; i < graphOfEachK[0].arcs.length; i++) {
        if (k + 1 > graphOfEachK.length - 1) {
          graphOfEachK[k].arcs[i].flow = 0.0;
          continue;
        }

        graphOfEachK[k].arcs[i].flow = graphOfEachK[k + 1].arcs[i].flow * 2;
      }

      var auxPath = graphOfEachK[k].breadthFirstSearch(start, end);
      var auxResidual = graphOfEachK[k].minResidualValue(auxPath.toList());
      graphOfEachK[k].increaseWithResidual(auxResidual, auxPath);
      k -= 1;
    }

    return graphOfEachK.first;
  }

  static Graph shortPathAhujaOrlin(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    // final int start = input.$2;
    // final int end = input.$3;

    return graph;
  }
}

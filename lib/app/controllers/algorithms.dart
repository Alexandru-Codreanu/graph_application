import 'dart:collection';
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
    double maxCapacity = double.minPositive;

    graph.setFlowToZero();
    for (var i = 0; i < graph.arcs.length; i++) {
      if (graph.arcs[i].capacity >= maxCapacity) {
        maxCapacity = graph.arcs[i].capacity;
      }
    }
    double residual = pow(2, log(maxCapacity) ~/ log(2)).toDouble();
    while (residual >= 1) {
      print(residual);
      do {
        augmentingPath = graph.breadthFirstSearchMS(start, end, residual);
        print(augmentingPath.toString());
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

    graph.setFlowToZero();

    double maxCapacity = graph.arcs.map((arc) => arc.capacity).reduce(max);

    if (maxCapacity <= 0) {
      return graph;
    }

    int kMax = (log(maxCapacity) / log(2)).floor();

    for (int k = kMax; k >= 0; k--) {
      double delta = (1 << k).toDouble();

      while (true) {
        Queue<int> queue = Queue();
        Map<int, (int prevNode, int arcIndex, bool isReverse)> parent = {};
        queue.add(start);
        parent[start] = (-1, -1, false);

        bool foundPath = false;

        while (queue.isNotEmpty) {
          int u = queue.removeFirst();
          if (u == end) {
            foundPath = true;
            break;
          }

          for (var adj in graph.adjacencyMap[u]!) {
            Arc arc = graph.arcs[adj.arcIndex];
            double residual = arc.capacity - arc.flow;
            if (residual >= delta) {
              int v = adj.secondNodeIndex;
              if (!parent.containsKey(v)) {
                parent[v] = (u, adj.arcIndex, false);
                queue.add(v);
              }
            }
          }

          for (int arcIndex = 0; arcIndex < graph.arcs.length; arcIndex++) {
            Arc arc = graph.arcs[arcIndex];
            if (arc.secondNode == u) {
              double residual = arc.flow;
              if (residual >= delta) {
                int v = arc.firstNode;
                if (!parent.containsKey(v)) {
                  parent[v] = (u, arcIndex, true);
                  queue.add(v);
                }
              }
            }
          }
        }

        if (!foundPath) {
          break;
        }

        List<(int arcIndex, bool isReverse)> pathEdges = [];
        double minResidual = double.infinity;
        int current = end;

        while (current != start) {
          var (prev, arcIndex, isReverse) = parent[current]!;
          pathEdges.add((arcIndex, isReverse));
          current = prev;
        }
        pathEdges = pathEdges.reversed.toList();

        for (var (arcIndex, isReverse) in pathEdges) {
          Arc arc = graph.arcs[arcIndex];
          double residual = isReverse ? arc.flow : (arc.capacity - arc.flow);
          if (residual < minResidual) minResidual = residual;
        }

        for (var (arcIndex, isReverse) in pathEdges) {
          Arc arc = graph.arcs[arcIndex];
          if (isReverse) {
            arc.flow -= minResidual;
          } else {
            arc.flow += minResidual;
          }
        }
      }
    }

    return graph;
  }
}

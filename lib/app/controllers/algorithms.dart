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
      while (auxPath.isNotEmpty) {
        var auxResidual = graphOfEachK[k].minResidualValue(auxPath.toList());
        graphOfEachK[k].increaseWithResidual(auxResidual, auxPath);
        auxPath = graphOfEachK[k].breadthFirstSearch(start, end);
      }

      k -= 1;
    }

    return graphOfEachK.first;
  }

  static Graph shortPathAhujaOrlin(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    List<int> distances = graph.getDistances(start, end);
    List<int> predecessors = List<int>.filled(graph.nodes.length, -1);
    List<Arc> arcs = List.empty(growable: true);
    int x = start;

    graph.setFlowToZero();
    print("Distance: $distances");

    while (distances[start] < graph.nodes.length) {
      var successors = graph.adjacencyMap[x]
              ?.where((element) => distances[x] == distances[element.secondNodeIndex] + 1 && graph.arcs[element.arcIndex].residualCapacity > 0.0)
              .toList() ??
          [];

      if (successors.isEmpty) {
        distances[x] = graph.adjacencyMap[x]!.map((e) => distances[e.secondNodeIndex] + 1).reduce(min);
        if (arcs.isNotEmpty) {
          arcs.removeLast();
        }
        if (x != start) {
          x = predecessors[x];
        }
        continue;
      }

      predecessors[successors.first.secondNodeIndex] = x;
      x = successors.first.secondNodeIndex;
      arcs.add(graph.arcs[successors.first.arcIndex]);

      if (x == end) {
        List<int> auxList = List.empty(growable: true);
        for (var i = 0; i < arcs.length; i++) {
          auxList.add(arcs[i].firstNode);
        }
        auxList.add(arcs.last.secondNode);
        var auxResidual = graph.minResidualValue(auxList.toList());
        graph.increaseWithResidual(auxResidual, auxList.toList());
        predecessors.fillRange(0, predecessors.length, -1);
        arcs.clear();
        x = start;
        distances = graph.getDistances(start, end);
        print("Distance: $distances");
      }
    }
    return graph;
  }

  static Graph shortPathAhujaOrlinB(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    List<int> distances = graph.getDistances(start, end);
    List<int> predecessors = List<int>.filled(graph.nodes.length, -1);
    List<bool> blocked = List<bool>.filled(graph.nodes.length, false);
    List<Arc> arcs = List.empty(growable: true);
    int x = start;

    graph.setFlowToZero();
    print("Distance: $distances");

    while (distances[start] < graph.nodes.length) {
      if (blocked[start]) {
        break;
      }

      var successors = graph.adjacencyMap[x]
              ?.where((element) =>
                  distances[x] == distances[element.secondNodeIndex] + 1 &&
                  !blocked[element.secondNodeIndex] &&
                  graph.arcs[element.arcIndex].residualCapacity > 0.0)
              .toList() ??
          [];

      if (successors.isEmpty) {
        if (arcs.isNotEmpty) {
          arcs.removeLast();
        }
        blocked[x] = true;
        if (x != start) {
          x = predecessors[x];
        }
        continue;
      }

      predecessors[successors.first.secondNodeIndex] = x;
      x = successors.first.secondNodeIndex;
      arcs.add(graph.arcs[successors.first.arcIndex]);

      if (x == end) {
        List<int> auxList = List.empty(growable: true);
        for (var i = 0; i < arcs.length; i++) {
          auxList.add(arcs[i].firstNode);
        }
        auxList.add(arcs.last.secondNode);
        var auxResidual = graph.minResidualValue(auxList.toList());
        graph.increaseWithResidual(auxResidual, auxList.toList());
        predecessors.fillRange(0, predecessors.length, -1);
        arcs.clear();
        x = start;
        distances = graph.getDistances(start, end);
        print("Distance: $distances");
      }
    }
    return graph;
  }

  static Graph stratifiedAhujaOrlin(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    List<int> predecessors = List<int>.filled(graph.nodes.length, -1);
    List<Arc> arcs = List.empty(growable: true);

    graph.setFlowToZero();
    List<int> distances = graph.getDistances(start, end);
    List<bool> blocked = List<bool>.filled(graph.nodes.length, false, growable: false);

    int x = start;
    while (distances[start] < graph.nodes.length) {
      if (!blocked[x]) {
        var successors = graph.adjacencyMap[x]
                ?.where((element) =>
                    distances[x] == distances[element.secondNodeIndex] + 1 &&
                    !blocked[element.secondNodeIndex] &&
                    graph.arcs[element.arcIndex].residualCapacity > 0.0)
                .toList() ??
            [];

        if (successors.isNotEmpty) {
          predecessors[successors.first.secondNodeIndex] = x;
          x = successors.first.secondNodeIndex;
          arcs.add(graph.arcs[successors.first.arcIndex]);

          if (x == end) {
            x = start;
            List<int> auxList = List.empty(growable: true);
            for (var i = 0; i < arcs.length; i++) {
              auxList.add(arcs[i].firstNode);
            }
            auxList.add(arcs.last.secondNode);
            var auxResidual = graph.minResidualValue(auxList.toList());
            graph.increaseWithResidual(auxResidual, auxList.toList());
            predecessors.fillRange(0, predecessors.length, -1);
            arcs.clear();
            x = start;
            distances = graph.getDistances(start, end);
            print("Distance: $distances");
          }
        } else {
          blocked[x] = true;
          if (x != start) {
            x = predecessors[x];
          }
        }
      } else {
        distances = graph.getDistances(start, end);
        blocked = List.filled(graph.nodes.length, false);
      }
    }

    return graph;
  }

  /// FIX
  static Graph genericPreflux(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;
    List<int> distances = [];
    List<int> activeNodes = [];
    Random random = Random(DateTime.now().millisecondsSinceEpoch);

    /// Initializare
    graph.setFlowToZero();
    distances = graph.getDistances(start, end);
    for (var i = 0; i < graph.adjacencyMap[start]!.length; i++) {
      var arc = graph.arcs[graph.adjacencyMap[start]![i].arcIndex];
      arc.flow = arc.capacity;
      if (arc.secondNode != end) {
        activeNodes.add(arc.secondNode);
      }
    }
    distances[start] = graph.nodes.length;

    while (activeNodes.isNotEmpty) {
      print("$activeNodes");
      var x = activeNodes.removeAt(random.nextInt(activeNodes.length));

      ///Inaintare/Reetichetare
      var admissibleArcs = graph.adjacencyMap[x]
              ?.where((element) => distances[x] == distances[element.secondNodeIndex] + 1 && graph.arcs[element.arcIndex].residualCapacity > 0.0)
              .toList() ??
          [];

      if (admissibleArcs.isNotEmpty) {
        graph.arcs[admissibleArcs.first.arcIndex].flow = min(graph.excessOf(x), graph.arcs[admissibleArcs.first.arcIndex].residualCapacity);
        if (admissibleArcs.first.secondNodeIndex == end) {
          continue;
        }

        activeNodes.add(admissibleArcs.first.secondNodeIndex);
      } else {
        distances[x] = graph.adjacencyMap[x]!
                .where((element) => graph.arcs[element.arcIndex].residualCapacity > 0.0)
                .map((e) => graph.arcs[e.arcIndex].residualCapacity)
                .reduce(min)
                .toInt() +
            1;
      }
    }

    return graph;
  }

  /// FIX
  static Graph prefluxFiFo(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;

    graph.setFlowToZero();
    final List<int> distances = graph.getDistances(start, end);
    final Queue c = Queue<int>();

    distances[start] = graph.nodes.length;

    graph.adjacencyMap[start]?.forEach((element) {
      graph.arcs[element.arcIndex].flow = graph.arcs[element.arcIndex].capacity;
      if (element.secondNodeIndex != end) {
        c.add(element.secondNodeIndex);
      }
    });

    while (c.isNotEmpty) {
      print("C: ${c.map((e) => e)}");

      int x = c.removeFirst();
      var admissibleArcs = graph.adjacencyMap[x]
              ?.where((element) => distances[x] == distances[element.secondNodeIndex] + 1 && graph.arcs[element.arcIndex].residualCapacity > 0.0)
              .toList() ??
          [];

      var excess = graph.excessOf(x);

      while (excess > 0 && admissibleArcs.isNotEmpty) {
        var first = admissibleArcs.removeAt(0);
        graph.arcs[first.arcIndex].flow += min(excess, graph.arcs[first.arcIndex].residualCapacity);
        if (graph.arcs[first.arcIndex].secondNode != start &&
            graph.arcs[first.arcIndex].secondNode != end &&
            !c.contains(graph.arcs[first.arcIndex].secondNode)) {
          c.add(graph.arcs[first.arcIndex].secondNode);
        }

        excess = graph.excessOf(x);
      }

      if (excess > 0) {
        var min = graph.nodes.length;
        var index = 0;

        for (var i = 0; i < graph.adjacencyMap[x]!.length; i++) {
          if (min < distances[graph.adjacencyMap[x]![i].secondNodeIndex]) {
            min = distances[graph.adjacencyMap[x]![i].secondNodeIndex];
            index = i;
          }
        }

        distances[x] = min + 1;
        c.add(graph.adjacencyMap[x]![index].secondNodeIndex);
      }
    }

    return graph;
  }

  /// IMPLEMENT
  static Graph prefluxHeap(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;

    return graph;
  }

  /// IMPLEMENT
  static Graph excessScaling(Map<String, Object> map) {
    final (Graph, int, int) input = handleInput(map);
    final Graph graph = input.$1;
    final int start = input.$2;
    final int end = input.$3;

    return graph;
  }
}

import 'adjacency.dart';
import 'arc.dart';
import 'graph.dart';
import 'node.dart';

class ResidualGraph {
  List<Node> nodes;
  List<ResidualArc> arcs;
  late Map<int, List<Adjacency>> adjacencyMap;

  ResidualGraph()
      : nodes = List<Node>.empty(growable: true),
        arcs = List<ResidualArc>.empty(growable: true),
        adjacencyMap = <int, List<Adjacency>>{};

  void fromGraph(Graph graph) {}

  Graph toGraph() {
    Graph graph = Graph.empty();

    return graph;
  }
}

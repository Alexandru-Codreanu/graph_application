class Arc {
  int firstNode;
  int secondNode;
  double capacity;
  double flow;

  Arc({
    required this.firstNode,
    required this.secondNode,
    required this.capacity,
    required this.flow,
  });

  Arc.fromJson({required dynamic json})
      : firstNode = json['first'] as int,
        secondNode = json['second'] as int,
        capacity = json['capacity'] as double,
        flow = json['flow'] as double;

  double get residualCapacity => capacity - flow;
}

class ResidualArc {
  int firstNode;
  int secondNode;
  int residual;

  ResidualArc({
    required this.firstNode,
    required this.secondNode,
    required this.residual,
  });
}

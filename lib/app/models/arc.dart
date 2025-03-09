class Arc {
  int firstNode;
  int secondNode;
  double capacity;
  double flow;
  bool isPath;

  Arc({
    required this.firstNode,
    required this.secondNode,
    required this.capacity,
    required this.flow,
  }) : isPath = false;

  Arc.fromJson({required dynamic json})
      : firstNode = json['first'] as int,
        secondNode = json['second'] as int,
        capacity = json['capacity'] as double,
        flow = json['flow'] as double,
        isPath = (json['isPath'] as bool?) ?? false;

  double get residualCapacity => capacity - flow;
}

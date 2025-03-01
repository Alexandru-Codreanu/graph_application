class Arc {
  final int firstNode;
  final int secondNode;
  final double capacity;
  final double flow;

  const Arc({
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
}

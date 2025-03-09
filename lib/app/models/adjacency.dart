class Adjacency {
  final int secondNodeIndex;
  final int arcIndex;

  Adjacency({
    required this.secondNodeIndex,
    required this.arcIndex,
  });

  @override
  bool operator ==(Object other) {
    if (other is! Adjacency) {
      return false;
    }

    return arcIndex == other.arcIndex && secondNodeIndex == other.secondNodeIndex;
  }

  @override
  int get hashCode => Object.hashAll([arcIndex, secondNodeIndex]);
}

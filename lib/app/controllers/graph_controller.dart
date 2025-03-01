import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import '../models/mode_enum.dart';
import '../models/graph.dart';

class GraphController {
  final ValueListenable<Graph> graphNotifier = ValueNotifier(Graph.empty());
  Graph get graph => graphNotifier.value;
  set graph(Graph value) {
    (graphNotifier as ValueNotifier).value = value;
  }

  final ValueListenable<XFile?> fileNotifier = ValueNotifier(null);
  XFile? get file => fileNotifier.value;
  set file(XFile? value) {
    (fileNotifier as ValueNotifier).value = value;
  }

  final ValueListenable<InteractionMode> interactionModeNotifier = ValueNotifier(InteractionMode.freeMove);
  InteractionMode get interactionMode => interactionModeNotifier.value;
  set interactionMode(InteractionMode value) {
    if (interactionModeNotifier.value == value) {
      return;
    }

    (interactionModeNotifier as ValueNotifier).value = value;
  }

  final ValueListenable<bool> isLoadingNotifier = ValueNotifier(false);
  bool get isLoading => isLoadingNotifier.value;
  set isLoading(bool value) {
    if (isLoadingNotifier.value == value) {
      return;
    }

    (isLoadingNotifier as ValueNotifier).value = value;
  }

  final ValueListenable<int> firstNodeInArchSelectedNotifier = ValueNotifier(-1);
  int get firstNodeInArchSelected => firstNodeInArchSelectedNotifier.value;
  set firstNodeInArchSelected(int value) {
    if (firstNodeInArchSelectedNotifier.value == value) {
      return;
    }

    if (value >= graph.nodes.length) {
      return;
    }

    (firstNodeInArchSelectedNotifier as ValueNotifier).value = value;
  }

  GraphController();
}

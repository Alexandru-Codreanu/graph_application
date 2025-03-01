import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import 'package:xml2json/xml2json.dart';
import '../models/arc.dart';
import '../models/graph.dart';
import '../models/node.dart';

abstract final class IsolateOperations {
  static dynamic decodeJson(XFile jsonFile) async {
    return jsonDecode(await jsonFile.readAsString());
  }

  static dynamic convertXMLtoJson(XFile xmlFile) async {
    final jsonTransformer = Xml2Json();
    jsonTransformer.parse(await xmlFile.readAsString());
    final json = jsonTransformer.toParker();
    return jsonDecode(json);
  }

  static Graph graphFromJson(dynamic json) {
    return Graph.fromJson(json: json);
  }

  static bool nodeExistsInProximity(Map<String, Object> map) {
    List<Node> nodes = map['nodes'] as List<Node>;
    Offset position = map['position'] as Offset;
    for (int i = 0; i < nodes.length; i++) {
      if ((nodes[i].position - position).distance <= 20.0) {
        return true;
      }
    }
    return false;
  }

  static int findNodeInProximity(Map<String, Object> map) {
    List<Node> nodes = map['nodes'] as List<Node>;
    Offset position = map['position'] as Offset;
    for (int i = 0; i < nodes.length; i++) {
      if ((nodes[i].position - position).distance <= 20.0) {
        return i;
      }
    }
    return -1;
  }

  static (int, bool) findArcByNodes(Map<String, Object> map) {
    List<Arc> arcs = map['arcs'] as List<Arc>;
    int firstNode = map['firstNode'] as int;
    int secondNode = map['secondNode'] as int;

    for (int i = 0; i < arcs.length; i++) {
      if (arcs[i].firstNode == firstNode && arcs[i].secondNode == secondNode) {
        return (i, true);
      }

      if (arcs[i].secondNode == firstNode && arcs[i].firstNode == secondNode) {
        return (i, false);
      }
    }

    return (-1, false);
  }
}

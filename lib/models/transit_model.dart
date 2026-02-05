import 'package:flutter/material.dart';

enum TransitType { btsSukhumvit, btsSilom, mrtBlue, walk }

class Station {
  final String id;
  final String name;
  final TransitType type;

  Station({required this.id, required this.name, required this.type});

  Color get color {
    switch (type) {
      case TransitType.btsSukhumvit: return Colors.lightGreen;
      case TransitType.btsSilom: return Colors.teal;
      case TransitType.mrtBlue: return Colors.blueAccent;
      case TransitType.walk: return Colors.grey;
    }
  }
}

class Edge {
  final Station destination;
  final int weight; // เวลาเดินทาง (นาที)
  final String? instruction;

  Edge(this.destination, this.weight, {this.instruction});
}
import 'dart:collection';
import '../models/transit_model.dart';
import '../repositories/transit_repository.dart';

class RouteCalculator {
  final TransitRepository repo;
  RouteCalculator(this.repo);

  Map<String, dynamic> findRoute(Station start, Station end) {
    if (start.id == end.id) return {};

    final graph = repo.getGraph();
    var distances = <String, int>{};
    var previous = <String, Station?>{};
    var priorityQueue = SplayTreeMap<int, List<String>>(); 

    for (var s in repo.stations.keys) {
      distances[s] = 999999;
    }
    distances[start.id] = 0;
    priorityQueue[0] = [start.id];

    while (priorityQueue.isNotEmpty) {
      var currentDist = priorityQueue.firstKey()!;
      var currentNodes = priorityQueue[currentDist]!;
      var uId = currentNodes.removeAt(0);
      
      if (currentNodes.isEmpty) priorityQueue.remove(currentDist);
      if (uId == end.id) break;

      if (graph.containsKey(uId)) {
        for (var edge in graph[uId]!) {
          var alt = distances[uId]! + edge.weight;
          if (alt < distances[edge.destination.id]!) {
            distances[edge.destination.id] = alt;
            previous[edge.destination.id] = repo.stations[uId];
            
            if (!priorityQueue.containsKey(alt)) priorityQueue[alt] = [];
            priorityQueue[alt]!.add(edge.destination.id);
          }
        }
      }
    }

    List<Station> path = [];
    Station? curr = end;
    while (curr != null) {
      path.insert(0, curr);
      curr = previous[curr.id];
    }

    if (path.isEmpty || path.first.id != start.id) return {};

    return {
      'path': path,
      'duration': distances[end.id],
      'price': 15 + (path.length * 5)
    };
  }
}
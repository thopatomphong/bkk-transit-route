import 'package:flutter/material.dart';
import '../models/transit_model.dart';
import '../repositories/transit_repository.dart';
import 'info_badge.dart'; // Import ไฟล์ย่อยข้างล่าง

class RouteTimeline extends StatelessWidget {
  final Map<String, dynamic> result;
  final TransitRepository repo;

  const RouteTimeline({super.key, required this.result, required this.repo});

  @override
  Widget build(BuildContext context) {
    final List<Station> path = result['path'];
    final int duration = result['duration'];
    final int price = result['price'];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.indigo.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoBadge(icon: Icons.timer, text: "$duration นาที"),
              InfoBadge(icon: Icons.attach_money, text: "$price บาท"),
              InfoBadge(
                icon: Icons.directions_subway,
                text: "${path.length} สถานี",
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: path.length,
            itemBuilder: (context, index) {
              final station = path[index];
              final isLast = index == path.length - 1;
              String? instruction;

              if (!isLast) {
                final connections = repo.getGraph()[station.id];
                final nextStationId = path[index + 1].id;
                final edge = connections?.firstWhere(
                  (e) => e.destination.id == nextStationId,
                  orElse: () => Edge(station, 0),
                );
                instruction = edge?.instruction;
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Column(
                        children: [
                          Container(
                            width: 2,
                            height: 15,
                            color: index == 0
                                ? Colors.transparent
                                : Colors.grey,
                          ),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: station.color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, color: Colors.black26),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 3,
                              color: isLast
                                  ? Colors.transparent
                                  : station.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              station.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (instruction != null)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.directions_walk,
                                      size: 14,
                                      color: Colors.brown,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      instruction,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

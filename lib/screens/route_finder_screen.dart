import 'package:flutter/material.dart';
import '../models/transit_model.dart';
import '../repositories/transit_repository.dart';
import '../services/route_calculator.dart';
import '../widgets/route_timeline.dart';

class RouteFinderScreen extends StatefulWidget {
  const RouteFinderScreen({super.key});

  @override
  State<RouteFinderScreen> createState() => _RouteFinderScreenState();
}

class _RouteFinderScreenState extends State<RouteFinderScreen> {
  final TransitRepository _repo = TransitRepository();
  late RouteCalculator _calculator;

  Station? _startStation;
  Station? _endStation;
  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _calculator = RouteCalculator(_repo);
  }

  void _calculate() {
    if (_startStation != null && _endStation != null) {
      setState(() {
        _result = _calculator.findRoute(_startStation!, _endStation!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Station> allStations = _repo.getAllStations();

    return Scaffold(
      appBar: AppBar(title: const Text("BKK Transit Route")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<Station>(
                    decoration: const InputDecoration(
                      labelText: 'ต้นทาง',
                      prefixIcon: Icon(Icons.trip_origin),
                    ),
                    value: _startStation,
                    items: allStations
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _startStation = val),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Station>(
                    decoration: const InputDecoration(
                      labelText: 'ปลายทาง',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    value: _endStation,
                    items: allStations
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _endStation = val),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text("ค้นหาเส้นทาง"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _calculate,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _result == null
                ? const Center(child: Text("กรุณาเลือกสถานีและกดค้นหา"))
                : _result!.isEmpty
                ? const Center(child: Text("ไม่พบเส้นทาง"))
                : RouteTimeline(result: _result!, repo: _repo),
          ),
        ],
      ),
    );
  }
}

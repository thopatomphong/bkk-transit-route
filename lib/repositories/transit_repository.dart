import '../models/transit_model.dart';

class TransitRepository {
  final Map<String, Station> stations = {
    'mo_chit': Station(id: 'mo_chit', name: 'หมอชิต (BTS)', type: TransitType.btsSukhumvit),
    'siam': Station(id: 'siam', name: 'สยาม (Interchange)', type: TransitType.btsSukhumvit),
    'asok': Station(id: 'asok', name: 'อโศก (BTS)', type: TransitType.btsSukhumvit),
    'siam_sil': Station(id: 'siam_sil', name: 'สยาม (Silom Line)', type: TransitType.btsSilom),
    'sala_daeng': Station(id: 'sala_daeng', name: 'ศาลาแดง (BTS)', type: TransitType.btsSilom),
    'chatuchak': Station(id: 'chatuchak', name: 'สวนจตุจักร (MRT)', type: TransitType.mrtBlue),
    'sukhumvit': Station(id: 'sukhumvit', name: 'สุขุมวิท (MRT)', type: TransitType.mrtBlue),
    'silom': Station(id: 'silom', name: 'สีลม (MRT)', type: TransitType.mrtBlue),
  };

  Map<String, List<Edge>> getGraph() {
    return {
      'mo_chit': [Edge(stations['siam']!, 10)],
      'siam': [
        Edge(stations['mo_chit']!, 10), 
        Edge(stations['asok']!, 8),
        Edge(stations['siam_sil']!, 2, instruction: "เดินเปลี่ยนชานชาลาไปสายสีลม") 
      ],
      'asok': [
        Edge(stations['siam']!, 8),
        Edge(stations['sukhumvit']!, 5, instruction: "เดิน Skywalk ไป MRT สุขุมวิท")
      ],
      'siam_sil': [
        Edge(stations['siam']!, 2, instruction: "เดินเปลี่ยนชานชาลาไปสายสุขุมวิท"),
        Edge(stations['sala_daeng']!, 5)
      ],
      'sala_daeng': [
        Edge(stations['siam_sil']!, 5),
        Edge(stations['silom']!, 8, instruction: "เดิน Skywalk ไป MRT สีลม")
      ],
      'chatuchak': [
        Edge(stations['sukhumvit']!, 15),
        Edge(stations['mo_chit']!, 5, instruction: "เดินขึ้นไป BTS หมอชิต")
      ],
      'sukhumvit': [
        Edge(stations['chatuchak']!, 15),
        Edge(stations['silom']!, 10),
        Edge(stations['asok']!, 5, instruction: "เดินขึ้นไป BTS อโศก")
      ],
      'silom': [
        Edge(stations['sukhumvit']!, 10),
        Edge(stations['sala_daeng']!, 8, instruction: "เดิน Skywalk ไป BTS ศาลาแดง")
      ]
    };
  }

  List<Station> getAllStations() => stations.values.toList();
}
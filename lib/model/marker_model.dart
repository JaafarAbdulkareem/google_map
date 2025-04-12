import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String id;
  final String name;
  final LatLng latLng;

  const MarkerModel({
    required this.id,
    required this.name,
    required this.latLng,
  });

  static List<MarkerModel> marker = const [
    MarkerModel(
      id: "1",
      name: "King",
      latLng: LatLng(
        13.022343863196378,
        77.63909922043815,
      ),
    ),
    MarkerModel(
      id: "1",
      name: "Some Thing",
      latLng: LatLng(
        13.010048923522781,
        77.55100088504592,
      ),
    ),
  ];
}

import 'lat_lng_model.dart';

class LocationModel {
  final LatLngModel latLng;

  LocationModel({required this.latLng});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        latLng: LatLngModel.fromJson(json['latLng'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'latLng': latLng.toJson(),
      };
}

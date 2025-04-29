import 'polyline_model.dart';

class RouteModel {
  final int distanceMeters;
  final String duration;
  final PolylineModel polyline;

  RouteModel(
      {required this.distanceMeters,
      required this.duration,
      required this.polyline});

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        distanceMeters: json['distanceMeters'],
        duration: json['duration'],
        polyline: PolylineModel.fromJson(json['polyline'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'distanceMeters': distanceMeters,
        'duration': duration,
        'polyline': polyline.toJson(),
      };
}

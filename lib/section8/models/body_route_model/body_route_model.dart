import 'destination_model.dart';
import 'origin_model.dart';
import 'route_modifiers_model.dart';

class BodyRouteModel {
  final OriginModel origin;
  final DestinationModel destination;
  final String travelMode;
  final String routingPreference;
  final bool computeAlternativeRoutes;
  final RouteModifiersModel routeModifiers;
  final String languageCode;
  final String units;
  BodyRouteModel(
      {required this.origin,
      required this.destination,
      required this.travelMode,
      required this.routingPreference,
      required this.computeAlternativeRoutes,
      required this.routeModifiers,
      required this.languageCode,
      required this.units});

  factory BodyRouteModel.fromJson(Map<String, dynamic> json) {
    return BodyRouteModel(
      origin: OriginModel.fromJson(json['origin'] as Map<String, dynamic>),
      destination:
          DestinationModel.fromJson(json['destination'] as Map<String, dynamic>),
      travelMode: json['travelMode'] as String,
      routingPreference: json['routingPreference'] as String,
      computeAlternativeRoutes: json['computeAlternativeRoutes'] as bool,
      routeModifiers: RouteModifiersModel.fromJson(
          json['routeModifiers'] as Map<String, dynamic>),
      languageCode: json['languageCode'] as String,
      units: json['units'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'origin': origin.toJson(),
        'destination': destination.toJson(),
        'travelMode': travelMode,
        'routingPreference': routingPreference,
        'computeAlternativeRoutes': computeAlternativeRoutes,
        'routeModifiers': routeModifiers.toJson(),
        'languageCode': languageCode,
        'units': units,
      };
}

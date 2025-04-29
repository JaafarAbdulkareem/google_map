import 'location_model.dart';

class DestinationModel {
  LocationModel location;

  DestinationModel({required this.location});

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      DestinationModel(
        location:
            LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
      };
}

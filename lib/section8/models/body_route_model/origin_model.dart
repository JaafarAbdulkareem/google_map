import 'location_model.dart';

class OriginModel {
  LocationModel location;

  OriginModel({required this.location});

  factory OriginModel.fromJson(Map<String, dynamic> json) => OriginModel(
        location:
            LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
      };
}

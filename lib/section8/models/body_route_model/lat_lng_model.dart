class LatLngModel {
  final double latitude;
  final double longitude;

  LatLngModel({required this.latitude, required this.longitude});

  factory LatLngModel.fromJson(Map<String, dynamic> json) => LatLngModel(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

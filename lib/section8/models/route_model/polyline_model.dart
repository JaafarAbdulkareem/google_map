class PolylineModel {
  final String encodedPolyline;

  PolylineModel({required this.encodedPolyline});

  factory PolylineModel.fromJson(Map<String, dynamic> json) => PolylineModel(
        encodedPolyline: json['encodedPolyline'] as String,
      );

  Map<String, dynamic> toJson() => {
        'encodedPolyline': encodedPolyline,
      };
}

class MatchedSubstringModel {
  final int length;
  final int offset;

  MatchedSubstringModel({
    required this.length,
    required this.offset,
  });

  factory MatchedSubstringModel.fromJson(Map<String, dynamic> json) {
    return MatchedSubstringModel(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

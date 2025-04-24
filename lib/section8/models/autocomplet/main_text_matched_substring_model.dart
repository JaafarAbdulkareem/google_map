class MainTextMatchedSubstringModel {
  final int length;
  final int offset;

  MainTextMatchedSubstringModel({
    required this.length,
    required this.offset,
  });

  factory MainTextMatchedSubstringModel.fromJson(Map<String, dynamic> json) {
    return MainTextMatchedSubstringModel(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

class TermModel {
  final int offset;
  final String value;

  TermModel({required this.offset, required this.value});

  factory TermModel.fromJson(Map<String, dynamic> json) => TermModel(
        offset: json['offset'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}

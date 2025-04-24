import 'main_text_matched_substring_model.dart';

class StructuredFormattingModel {
  String mainText;
  List<MainTextMatchedSubstringModel> mainTextMatchedSubstrings;

  StructuredFormattingModel(
      {required this.mainText, required this.mainTextMatchedSubstrings});

  factory StructuredFormattingModel.fromJson(Map<String, dynamic> json) {
    return StructuredFormattingModel(
      mainText: json['main_text'],
      mainTextMatchedSubstrings:
          (json['main_text_matched_substrings'] as List<dynamic>)
              .map((e) => MainTextMatchedSubstringModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings':
            mainTextMatchedSubstrings.map((e) => e.toJson()).toList(),
      };
}

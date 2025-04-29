import 'matched_substring_model.dart';
import 'structured_formatting_model.dart';
import 'term_model.dart';

class AutocompleteModel {
  final String description;
  final List<MatchedSubstringModel> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormattingModel? structuredFormatting;
  final List<TermModel>? terms;
  final List<String> types;

  AutocompleteModel({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  factory AutocompleteModel.fromJson(Map<String, dynamic> json) =>
      AutocompleteModel(
        description: json['description'],
        matchedSubstrings: (json['matched_substrings'] as List<dynamic>)
            .map((e) => MatchedSubstringModel.fromJson(e))
            .toList(),
        // (json['matched_substrings'])?.map((e) => MatchedSubstringModel.fromJson(e))
        // .toList(),
        placeId: json['place_id'],
        reference: json['reference'],
        structuredFormatting: json['structured_formatting'] == null
            ? null
            : StructuredFormattingModel.fromJson(
                json['structured_formatting'] as Map<String, dynamic>),
        terms: (json['terms'] as List<dynamic>)
            .map((e) => TermModel.fromJson(e))
            .toList(),
        types:
            (json['types'] as List<dynamic>).map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'matched_substrings': matchedSubstrings.map((e) => e.toJson()).toList(),
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting?.toJson(),
        'terms': terms?.map((e) => e.toJson()).toList(),
        'types': types,
      };
}

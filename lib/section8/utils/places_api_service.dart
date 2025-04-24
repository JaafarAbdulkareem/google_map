import 'dart:convert';

import 'package:google_map/section8/models/autocomplet/autocomplet_model.dart';
import 'package:google_map/section8/models/place_detail_model/place_detail_model.dart';
import 'package:http/http.dart' as https;

class PlacesApiService {
  //

  final String baseApi = "https://maps.googleapis.com/maps/api/place";
  final String apiKey = "AIzaSyC2VOiVQJXqM85UY1DYkq2zAfp3UxSR6_Q";
  Future<List<AutocompleteModel>> getAutocompleteApi({
    required String input,
    required String sessiontoken,
  }) async {
    final String autocompleteApi =
        "$baseApi/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sessiontoken";
    List<AutocompleteModel> autocompletData = [];
    var response = await https.get(Uri.parse(autocompleteApi));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var bodyResponse = jsonDecode(response.body)["predictions"];
      for (var element in bodyResponse) {
        autocompletData.add(AutocompleteModel.fromJson(element));
      }
      return autocompletData;
    } else {
      throw AutocompleteException();
    }
  }

  Future<PlaceDetailModel> getPlaceDetailApi({
    required String placeId,
  }) async {
    final String autocompleteApi =
        "$baseApi/details/json?key=$apiKey&place_id=$placeId";

    var response = await https.get(Uri.parse(autocompleteApi));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var bodyResponse = jsonDecode(response.body)["result"];

      return PlaceDetailModel.fromJson(bodyResponse);
    } else {
      throw PlaceDetailException();
    }
  }
}

class AutocompleteException implements Exception {}

class PlaceDetailException implements Exception {}

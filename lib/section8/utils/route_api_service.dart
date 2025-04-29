import 'dart:convert';
import 'package:google_map/section8/models/body_route_model/body_route_model.dart';
import 'package:google_map/section8/models/route_model/route_model.dart';
import 'package:http/http.dart' as http;

class RouteApiService {
  final String baseApi =
      "https://routes.googleapis.com/directions/v2:computeRoutes";
  final String apiKey = "AIzaSyC2VOiVQJXqM85UY1DYkq2zAfp3UxSR6_Q";
  Future<RouteModel> getRouteApi({required BodyRouteModel bodyRoute}) async {
    final String routeApi = baseApi;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
    };
    Map<String, dynamic> body = {
      "origin": bodyRoute.origin.toJson(),
      "destination": bodyRoute.destination.toJson(),
      "travelMode": bodyRoute.travelMode,
      "routingPreference": bodyRoute.routingPreference,
      "computeAlternativeRoutes": bodyRoute.computeAlternativeRoutes,
      "routeModifiers": bodyRoute.routeModifiers,
      "languageCode": bodyRoute.languageCode,
      "units": bodyRoute.units
    };
    var response = await http.post(
      Uri.parse(routeApi),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonData = jsonDecode(response.body)["routes"];
      RouteModel dataRoute = RouteModel.fromJson(jsonData.first);
      return dataRoute;
    } else {
      throw RouteException();
    }
  }
}

class RouteException implements Exception {}
